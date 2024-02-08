

extends CharacterBody2D
class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const SECOND_JUMP_VELOCITY = -150.0
const ACCELERATION = 500
const FRICTION = 600
const AIR_ACCELERATION = 250

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 0
var max_jump = 2
var can_double_jump = true
var current_checkpoint : Checkpoint = null
var stored_wall_normal = Vector2.ZERO


#variables for dash ability
var dash_direction = Vector2(1,0)
var can_dash = false
var dashing = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var starting_position = global_position
@onready var coyote_timer = $CoyoteTimer
@onready var wall_jump_timer = $WallJumpTimer

@onready var spikes_sound = $Sounds/SpikesSound
@onready var jump_sound = $Sounds/JumpSound
@onready var dash_sound = $Sounds/DashSound

@onready var dust_particles = $DustParticles




func _ready():	
	if Allcheckpoints.spawn:
		global_position = Allcheckpoints.spawn
	else:
		global_position = starting_position

func _physics_process(delta):
	apply_dash()
	apply_gravity(delta)
	var direction = Input.get_axis("ui_left", "ui_right")
	apply_acceleration(direction, delta)
	apply_air_acceleration(direction, delta)
	apply_friction(direction, delta)
	apply_jump()
	apply_wall_jump()
	update_animation(direction)
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	if was_on_wall:
		stored_wall_normal = get_wall_normal()
	move_and_slide()
	var just_left_floor = was_on_floor and not is_on_floor() and velocity.y >= 0
	if (just_left_floor):
		coyote_timer.start()
	if is_on_floor():
		jump_count = 0
		can_double_jump = true
	var just_left_wall = was_on_wall and not is_on_wall()
	if just_left_wall:
		wall_jump_timer.start()
		

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func apply_acceleration(direction, delta): 	
	if not is_on_floor():
		return
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	
func apply_air_acceleration(direction, delta):
	if is_on_floor():
		return
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, AIR_ACCELERATION * delta)
	
	
func apply_friction(direction, delta):
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func apply_jump():
	if is_on_floor() or (can_double_jump && jump_count < max_jump) or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_accept"):
			if is_on_floor():
				jump_sound.play()
				velocity.y = JUMP_VELOCITY
				jump_count += 1
			else:
				velocity.y = SECOND_JUMP_VELOCITY
				jump_sound.play()
				jump_count = 1
				can_double_jump = false
				
func apply_wall_jump():
	if not is_on_wall_only() and wall_jump_timer.time_left <= 0.0:
		return
	var wall_normal = get_wall_normal()
	if wall_jump_timer.time_left > 0.0:
		wall_normal = stored_wall_normal
		
	if (Input.is_action_just_pressed("ui_left") and wall_normal == Vector2.LEFT):
		velocity.x = wall_normal.x * SPEED
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		
	if (Input.is_action_just_pressed("ui_right") and wall_normal == Vector2.RIGHT):
		velocity.x = wall_normal.x * SPEED
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		

# press D to dash 
# added dust particles to dash ability
func apply_dash():
	if is_on_floor():
		can_dash=true
	if Input.is_action_pressed("ui_right"):
		dash_direction = Vector2(1,0)
	if Input.is_action_pressed("ui_left"):
		dash_direction = Vector2(-1,0)
	if Input.is_action_just_pressed("ui_dash") and can_dash:
		dash_sound.play()
		velocity = dash_direction.normalized() *500	
		can_dash = false
		dashing = true
		dust_particles.emitting = true
		await get_tree().create_timer(0.2).timeout
		dashing = false
		dust_particles.emitting = false
				
func update_animation(direction):
	if direction != 0:
		animated_sprite_2d.flip_h = (direction < 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	if not is_on_floor():
		animated_sprite_2d.play("jump")
		
# this function is for when the player hits spikes		
func _on_detector_area_entered(_area):
	spikes_sound.play()
	animated_sprite_2d.modulate = Color.DARK_RED
	await get_tree().create_timer(0.10).timeout
	animated_sprite_2d.modulate = Color.WHITE
	await get_tree().create_timer(0.20).timeout	
	if Allcheckpoints.spawn:
		global_position = Allcheckpoints.spawn
	else:
		global_position = starting_position
	


