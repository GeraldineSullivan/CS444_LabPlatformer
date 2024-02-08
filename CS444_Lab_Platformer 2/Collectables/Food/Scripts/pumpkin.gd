extends Area2D

@onready var pumpkin_eat = $pumpkin_eat


var collected: bool = false

func _on_body_entered(_body):
	if not collected:
		PumpkinManager.gain_pumpkins(1)
		if PumpkinManager.pumpkins > 0:
			pumpkin_eat.play()
		var tween = create_tween()
		tween.tween_property(self, "position", position + Vector2(0, -25), 0.2)
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		tween.tween_callback(self.queue_free)
		modulate = Color.ORANGE
		collected = true  # prevent recollection
		
	
	
		

