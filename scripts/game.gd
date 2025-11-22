extends Node2D

@export var head: Head

@export var barriers: Node2D
@export var barrier_spawn_timer: Timer

@export var apples: Node2D
@export var apple_spawn_timer: Timer

@export var camera: Camera2D
@export var ui: CanvasLayer
@export var tutorial: Sprite2D

@export var score_label: Label
@export var highscore_label: Label

@export var ui_animation: AnimationPlayer
@export var secrets: Node2D

@onready var audio_death: AudioStreamPlayer = $AudioDeath

var score: float = 0
var highscore: float = 0
var on_tutorial: bool = false
var may_spawn_laser: bool = true

var tutorial_tween: Tween

func _ready() -> void:
	head.restart.connect(on_restart)
	head.fire_cooldown.timeout.connect(set.bind("may_spawn_laser", true))
	
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
	
	if Input.is_action_just_pressed("hit") and on_tutorial:
		tutorial_tween = create_tween()
		tutorial_tween.set_trans(Tween.TRANS_LINEAR)
		tutorial_tween.tween_property(tutorial, "self_modulate:a", 0, 0.5)
		tutorial_tween.tween_callback(get_tree().reload_current_scene)

func _on_barrier_spawn_timer_timeout() -> void:
	if may_spawn_laser and randi_range(0, 4) == 0:
		var laser: Laser = Laser.instantiate()
		laser.global_position = Vector2(int(head.global_position.x) + 300.5, -13.5)
		laser.last.connect(set.bind("may_spawn_laser", false))
		barriers.add_child(laser)
	else:
		var barrier: Barrier = Barrier.instantiate()
		barrier.global_position = Vector2(int(head.global_position.x) + 300.5, -13.5)
		barriers.add_child(barrier)

func on_restart() -> void:
	audio_death.play(0.3)
	
	for secret in secrets.get_children():
		secret.queue_free()
	
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
	
	for apple in apples.get_children():
		apple.queue_free()
	
	barrier_spawn_timer.stop()
	apple_spawn_timer.stop()
	may_spawn_laser = true
	
	if score > highscore:
		highscore = score
	
	var file: FileAccess = FileAccess.open("user://gamedata.data", FileAccess.WRITE)
	file.store_var(highscore)
	file.close()
	
	head.input_mode = 0
	await get_tree().create_timer(0.5).timeout
	head.input_mode = 2

func _on_tutorial_button_pressed() -> void:
	on_tutorial = true
	
	ui.follow_viewport_enabled = true
	ui.offset -= get_viewport_rect().size / 2 + Vector2(0, 20)
	
	tutorial_tween = create_tween()
	
	tutorial_tween.set_ease(Tween.EASE_IN_OUT)
	tutorial_tween.set_trans(Tween.TRANS_CUBIC)
	
	tutorial_tween.tween_property(camera, "global_position:y", 200, 1)

func _on_apple_spawn_timer_timeout() -> void:
	apple_spawn_timer.wait_time = 8
	
	var apple: Apple = Apple.instantiate()
	apple.global_position = Vector2(int(head.global_position.x) + 300, randi_range(-25, 25))
	apples.add_child(apple)
