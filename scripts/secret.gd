extends Sprite2D

@export var secrets: Node2D

var Secret: PackedScene = preload("res://scenes/secret.tscn")

var last_pos_x: float = global_position.x

func _process(_delta: float) -> void:
	if last_pos_x != global_position.x:
		if randi_range(0, 32) == 0:
			var secret: Sprite2D = Secret.instantiate()
			secret.global_position = Vector2(global_position.x + 372, -20)
			secrets.add_child(secret)
		
		last_pos_x = global_position.x
