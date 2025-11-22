extends Area2D
class_name Apple

static func instantiate() -> Apple:
	return preload("res://scenes/apple.tscn").instantiate() as Apple

func _on_body_entered(body: Node2D) -> void:
	if body is Head:
		if not body.dash_cooldown.is_stopped():
			var time: float = body.dash_cooldown.time_left
			
			body.dash_cooldown.stop()
			body.dash_cooldown.start(max(time - 2, 0.05))
		
		queue_free()
