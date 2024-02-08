extends Node

var levels = {}
@export var first_level = "1"
@export var current_level = first_level
@export var level_directory = "res://levels"


func _ready():
	read_level_files()
	list_levels()
	#list_world_scene()
	#changeLevel("3")
	get_next_level()

# Reads all available levels located in the level_directory folder and stores it for internal use.
func read_level_files():
	var dir = DirAccess.open(level_directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var level_name = file_name.replace(".tscn","").replace("level_", "")
			if not dir.current_is_dir() and file_name.begins_with("level_") and file_name.ends_with(".tscn"):
				levels[level_name] = str(dir.get_current_dir(), "/", file_name)
				#print ("Added: ", level_name, " -> ", str(dir.get_current_dir(), "/", file_name))
			file_name = dir.get_next()
	else:
		print("Error when trying to access level path '", level_directory, "'")
		
# Debug output that lists all levels that have been detected.
func list_levels():
	print ("Level directory: ", level_directory)
	print ("List all values")
	for i in levels:
		print (levels[i])

func get_current_level():
	return current_level
	
func get_next_level():
	return str(int(get_current_level()) + 1)

# Changes to a specific level
func changeLevel(level_number):
	get_tree().change_scene_to_file(str("res://levels/level_", level_number, ".tscn"))
	current_level = str(level_number)
