extends Node2D

@export var head: Head
@export var score_label: Label
@export var barriers: Node2D
@export var barrier_spawn_timer: Timer

var score: float = 0

func _ready() -> void:
	head.restart.connect(on_restart)

func _physics_process(_delta: float) -> void:
	if head.state == head.State.FLY:
		score = head.global_position.x
		score_label.text = "score: " + str(round(score) / 10)

func _on_barrier_spawn_timer_timeout() -> void:
	var barrier: Barrier = Barrier.instantiate()
	barrier.global_position = Vector2(int(head.global_position.x) + 300.5, -13.5)
	barriers.add_child(barrier)

func on_restart() -> void:
	head.global_position.x = 0
	head.state = head.State.BOUNCE
	
	for barrier in barriers.get_children():
		barrier.queue_free()
	
	barrier_spawn_timer.stop()
