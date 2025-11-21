extends Node2D
class_name Barrier

static func instantiate() -> Barrier:
	return preload("res://scenes/barrier.tscn").instantiate() as Barrier

func _ready() -> void:
	var weak_point: WeakPoint = WeakPoint.instantiate()
	weak_point.position = Vector2(-10, randf_range(-30, 30))
	add_child(weak_point)
