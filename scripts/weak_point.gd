extends Area2D
class_name WeakPoint

static func instantiate() -> WeakPoint:
	return preload("res://scenes/weak_point.tscn").instantiate() as WeakPoint
