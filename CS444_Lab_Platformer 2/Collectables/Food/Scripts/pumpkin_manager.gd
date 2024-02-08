extends Node


signal gained_pumpkins()
var pumpkins: int
var player: Player

func _ready():
	pumpkins = 0

func gain_pumpkins(pumpkins_gained):
	pumpkins += pumpkins_gained
	emit_signal("gained_pumpkins")
	print(pumpkins)
	
func reset_pumpkins():
	pumpkins = -1
