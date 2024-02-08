extends Area2D

@onready var audio_stream_player = $AudioStreamPlayer

var collected: bool = false

func _on_body_entered(_body):
	if not collected:
		#counter goes up by one when heart collected.
		HeartManager.gain_hearts(1)
		#play sound
		if HeartManager.hearts > 0:
			audio_stream_player.play()
		#to move the hearts, added tween
		var tween = create_tween()
		tween.tween_property(self, "position", position + Vector2(0, -25), 0.2)
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		tween.tween_callback(self.queue_free)
		#turn heart red
		modulate = Color.RED
		#boolean used to prevent the heart collecting twice
		collected = true  
	


