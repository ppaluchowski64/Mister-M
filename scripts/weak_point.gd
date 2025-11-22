extends Area2D
class_name WeakPoint

static func instantiate() -> WeakPoint:
	return preload("res://scenes/weak_point.tscn").instantiate() as WeakPoint

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Head:
		get_parent().sunk = true
