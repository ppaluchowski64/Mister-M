extends Node2D

@export var head: Head
@export var barriers: Node2D
@export var barrier_spawn_timer: Timer

@export var score_label: Label
@export var highscore_label: Label

@export var ui_animation: AnimationPlayer

var score: float = 0
var highscore: float = 0

func _ready() -> void:
	head.restart.connect(on_restart)
	
	if FileAccess.file_exists("user://gamedata.data"):
		var file: FileAccess = FileAccess.open("user://gamedata.data", FileAccess.READ)
		highscore = file.get_var()
		file.close()
	else:
		var file: FileAccess = FileAccess.open("user://gamedata.data", FileAccess.WRITE)
		file.store_var(highscore)
		file.close()

func _physics_process(_delta: float) -> void:
	if head.state == head.State.FLY or head.state == head.State.DASH:
		score = head.global_position.x
		score_label.text = "score: " + str(round(score) / 10)
	
	highscore_label.text = "highscore: " + str(round(highscore) / 10)
	
	if Input.is_action_just_pressed("hit") and ui_animation.current_animation == "middle":
		ui_animation.play("exit")

func _on_barrier_spawn_timer_timeout() -> void:
	if head.fire_cooldown.is_stopped() and randi_range(0, 4) == 0:
		var laser: Laser = Laser.instantiate()
		laser.global_position = Vector2(int(head.global_position.x) + 300.5, -13.5)
		barriers.add_child(laser)
	else:
		var barrier: Barrier = Barrier.instantiate()
		barrier.global_position = Vector2(int(head.global_position.x) + 300.5, -13.5)
		barriers.add_child(barrier)

func on_restart() -> void:
	head.global_position.x = 0
	head.linear_velocity = Vector2.ZERO
	head.state = head.State.BOUNCE
	head.freeze = false
	
	head.sprite.frame = 0
	head.dash_cooldown.stop()
	head.fire_cooldown.stop()
	
	if head.anim_tween:
		head.anim_tween.kill()
	
	for barrier in barriers.get_children():
		barrier.queue_free()
	
	barrier_spawn_timer.stop()
	
	if score > highscore:
		highscore = score
	
	var file: FileAccess = FileAccess.open("user://gamedata.data", FileAccess.WRITE)
	file.store_var(highscore)
	file.close()
