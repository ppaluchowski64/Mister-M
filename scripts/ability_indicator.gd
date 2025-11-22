extends Sprite2D
class_name AbilityIndicator

@onready var rect: ColorRect = $ColorRect

var value: float = 1

func _physics_process(_delta: float) -> void:
	rect.size.y = value * 18
	rect.position.y = 9 - rect.size.y 
