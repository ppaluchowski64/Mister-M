extends RigidBody2D
class_name Head

@export var barrier_spawn_timer: Timer
@export var body_sprite: AnimatedSprite2D

enum State {BOUNCE, FLY}
var state: State = State.BOUNCE

func _physics_process(_delta: float) -> void:
	match state:
		State.BOUNCE:
			global_position.x = 0
			
			if global_position.y > 0:
				apply_impulse(Vector2i(0, -50))
				angular_velocity = 5
				
				if not body_sprite.is_playing():
					body_sprite.play()
			
			if Input.is_action_just_pressed("hit"):
				state = State.FLY
				apply_impulse(Vector2i(200, -100))
				barrier_spawn_timer.start()
		
		State.FLY:
			apply_force(Vector2(0, -700))
			
			angular_velocity = 2
			
			if Input.is_action_just_pressed("up"):
				if linear_velocity.x < 100:
					linear_velocity.y = -120 * linear_velocity.x / 100 + 20
				else:
					linear_velocity.y = -100
