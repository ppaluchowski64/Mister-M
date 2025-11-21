extends Camera2D

@export var head: Head

func _physics_process(_delta: float) -> void:
	var target_x: float = head.global_position.x + (0 if head.state == head.State.BOUNCE else 100)
	global_position.x = lerp(global_position.x, target_x, 0.2)
