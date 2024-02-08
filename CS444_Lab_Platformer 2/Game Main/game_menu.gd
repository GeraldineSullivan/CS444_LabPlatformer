extends CenterContainer


@onready var start_game_button = %StartGameButton

func _ready():
	start_game_button.grab_focus()
	RenderingServer.set_default_clear_color(Color.BLACK)


func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")

func _on_exit_game_button_pressed():
	get_tree().quit()

