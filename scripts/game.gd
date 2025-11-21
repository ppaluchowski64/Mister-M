extends Node2D

@export var head: Head
@export var score_label: Label

var score: float = 0

func _physics_process(_delta: float) -> void:
	if head.state == head.State.FLY:
		score = head.global_position.x
		score_label.text = "score: " + str(round(score) / 10)

func _on_barier_spawn_timer_timeout() -> void:
	var barrier: Barrier = Barrier.instantiate()
	barrier.global_position = Vector2(int(head.global_position.x) + 300.5, -13.5)
	add_child(barrier)
