extends RigidBody2D
class_name Head

@export var barrier_spawn_timer: Timer
@export var body_sprite: AnimatedSprite2D
@export var fire_tint: ColorRect

@export var dash_indicator: AbilityIndicator
@export var fire_indicator: AbilityIndicator

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $CPUParticles2D

@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashCooldown
@onready var laser_death_timer: Timer = $LaserDeathTimer
@onready var fire_timer: Timer = $FireTimer
@onready var fire_cooldown: Timer = $FireCooldown

@onready var glasses_sprite: Sprite2D = $GlassesSprite

enum State {BOUNCE, FLY, DASH}
var state: State = State.BOUNCE

var dash_y: float
var on_fire: bool = false

@export var input_mode: int = 0

var anim_tween: Tween
var fire_tint_tween: Tween

signal restart

func _physics_process(_delta: float) -> void:
	if not laser_death_timer.is_stopped():
		return
	
	match state:
		State.BOUNCE:
			global_position.x = 0
			
			if global_position.y > -5:
				apply_impulse(Vector2i(0, -50))
				angular_velocity = 5
				
				if not body_sprite.is_playing():
					body_sprite.play()
			
			if (Input.is_action_just_pressed("hit") and input_mode == 2) or input_mode == 1:
				if input_mode == 1:
					input_mode = 2
					remove_child(glasses_sprite)
				
				state = State.FLY
				apply_impulse(Vector2i(200, -100))
				barrier_spawn_timer.start()
		
		State.FLY:
			apply_force(Vector2(0, -700))
			
			angular_velocity = 2
			
			if linear_velocity.x < 26:
				restart.emit()
			
			if Input.is_action_just_pressed("dash") and dash_cooldown.is_stopped() and not on_fire:
				state = State.DASH
				sprite.frame = 1
				dash_y = global_position.y
				particles.emitting = true
				
				dash_timer.start()
				dash_cooldown.start()
			
			elif Input.is_action_just_pressed("fire") and fire_cooldown.is_stopped():
				on_fire = true
				
				sprite.frame = 3
				
				anim_tween = create_tween()
				anim_tween.set_trans(Tween.TRANS_LINEAR)
				
				for i in range(3):
					anim_tween.tween_property(sprite, "frame", 10, 0.5)
					anim_tween.tween_property(sprite, "frame", 3, 0)
				
				fire_tint_tween = create_tween()
				fire_tint_tween.tween_property(fire_tint, "color:a", 0.25, 0.25)
				
				fire_timer.start()
				fire_cooldown.start()
			
			elif Input.is_action_just_pressed("up"):
				if linear_velocity.x < 100:
					linear_velocity.y = -120 * linear_velocity.x / 100 + 20
				else:
					linear_velocity.y = -100
		
		State.DASH:
			linear_velocity.y = 0
			angular_velocity = 0
			
			global_position.y = dash_y
			global_rotation = lerp_angle(global_rotation, 0, 0.2)
			
			if linear_velocity.x < 500:
				apply_force(Vector2i(300, 0))
	
	dash_indicator.value = (10 - dash_cooldown.time_left) / 10
	fire_indicator.value = (15 - fire_cooldown.time_left) / 15

func _on_dash_timer_timeout() -> void:
	state = State.FLY
	sprite.frame = 0
	particles.emitting = false

func _on_laser_death_timer_timeout() -> void:
	restart.emit()

func _on_fire_timer_timeout() -> void:
	on_fire = false
	anim_tween.kill()
	sprite.frame = 0
	
	fire_tint_tween = create_tween()
	fire_tint_tween.tween_property(fire_tint, "color:a", 0, 1.5)
