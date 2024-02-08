extends Node2D

const FILE_BEGINNING = "res://levels/level_"
const HUD = preload("res://Game Main/HUD.tscn")
signal level_complete_signal

func _on_area_entered(area):
	# if the hearts are less than 60, Player cannot progress through the end level portal
	if area.is_in_group("Player")&& HeartManager.hearts > 60:
		#print("collided with player")
		var current_scene_file = get_tree().current_scene.scene_file_path
		#print(current_scene_file)
		#var current_level_number = current_scene_file.to_int()
		var next_level_number = current_scene_file.to_int()+1
		#print(next_level_number)
		var next_level_path = FILE_BEGINNING + str(next_level_number) + ".tscn"
		#reset the number of hearts at the end of a level so it starts at 0 next level
		HeartManager.reset_hearts()
		#Reset the pumpkin count to prevent it picking up a phantom pumpkin at the start of the next level
		PumpkinManager.reset_pumpkins()
		#this line resets the checkpoints, so player drops in at the beginning of next level
		Allcheckpoints.spawn = null
		#print(next_level_path)
		LevelTransition.fade_to_black()
		if ResourceLoader.exists(next_level_path):
			get_tree().change_scene_to_file(next_level_path)
			LevelTransition.fade_from_black()
		else:
			var center_container = CenterContainer.new()
			add_child(center_container)
			var game_over_label = Label.new()
			game_over_label.text = "Game Over"
			center_container.add_child(game_over_label)
			await get_tree().create_timer(3.0).timeout
			center_container.queue_free()
			get_tree().quit()
		
		
			
	#Display a message if the player has less than 50 hearts
	else:
		var label_instance = HUD.instantiate()
		label_instance.visible = true
		add_child(label_instance)
		await get_tree().create_timer(2.0).timeout
		label_instance.visible = false

		
