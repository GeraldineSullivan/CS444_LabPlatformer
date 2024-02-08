extends CanvasLayer


func _ready():
	HeartManager.gained_hearts.connect(update_heart_display)
	
func update_heart_display():
	$HeartDisplay.text = str(HeartManager.hearts)
	


