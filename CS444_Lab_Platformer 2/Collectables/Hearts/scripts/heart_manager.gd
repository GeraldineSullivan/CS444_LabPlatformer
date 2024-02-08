extends Node


signal gained_hearts()
var hearts: int
var player: Player

func _ready():
	hearts = -1

func gain_hearts(hearts_gained):
	hearts += hearts_gained
	emit_signal("gained_hearts")
	print(hearts)
	
func reset_hearts():
	hearts = 0

	
