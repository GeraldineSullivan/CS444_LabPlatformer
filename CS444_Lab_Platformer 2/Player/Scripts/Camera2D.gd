extends Camera2D

@export var random_strength: float= 0.5
@export var shake_fade: float = 0.6


var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0 


func _physics_process(delta):
	var current_scene_file = get_tree().current_scene.scene_file_path
	var current_level_number = current_scene_file.to_int()		
	
	if current_level_number == 4:
		apply_shake()
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
		offset = random_offset()
		

func apply_shake():
	shake_strength = random_strength
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))
	
