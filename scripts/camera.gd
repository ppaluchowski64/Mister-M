extends Camera2D

@export var head: Head

var shake_tween: Tween
var shake_value: float = 0

var shake_time: float = 0.3
var shake_intensity: float = 7.5
var shake_smoothness: float = 0.5

func shake() -> void:
	shake_tween = create_tween()
	
	shake_value = 0
	shake_tween.tween_property(self, "shake_value", 1, shake_time)

func _physics_process(_delta: float) -> void:
	var target_x: float = head.global_position.x + (0 if head.state == head.State.BOUNCE else 100)
	global_position.x = lerp(global_position.x, target_x, 0.2)
	
	if shake_tween and shake_tween.is_running():
		var target: Vector2 = Vector2.RIGHT.rotated(randf_range(-PI, PI)) * sin(shake_value * PI) * shake_intensity
		offset = lerp(offset, target, 1 - shake_smoothness)
	else:
		offset = Vector2.ZERO
