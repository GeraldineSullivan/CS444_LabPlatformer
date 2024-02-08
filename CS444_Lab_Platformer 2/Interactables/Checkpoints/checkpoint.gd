extends Node2D
class_name Checkpoint

var activated = false


func activate():
	activated = true
	$Checkflag.play("visited")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player && !activated:
		activate()
		Allcheckpoints.spawn = global_position
	
