extends Node2D

@export var head: Head
@export var score_label: Label

var score: float = 0

func _physics_process(_delta: float) -> void:
	score = head.global_position.x
	score_label.text = "score: " + str(round(score) / 10)

func _on_barier_spawn_timer_timeout() -> void:
	var barrier: Barrier = Barrier.instantiate()
	barrier.global_position = Vector2(head.global_position.x + 200, -20)
	add_child(barrier)
