extends RigidBody2D
class_name Head

@export var barrier_spawn_timer: Timer

enum State {BOUNCE, FLY}
var state: State = State.BOUNCE

var force_x: float = 30

func _physics_process(delta: float) -> void:
	match state:
		State.BOUNCE:
			if global_position.y > 0:
				apply_impulse(Vector2i(0, -50))
				angular_velocity = 5
			
			if Input.is_action_just_pressed("hit"):
				state = State.FLY
				apply_impulse(Vector2i(200, -100))
				barrier_spawn_timer.start()
		
		State.FLY:
			apply_force(Vector2(force_x, -700))
			force_x = max(force_x - delta, 0)
			
			angular_velocity = 2
			
			if Input.is_action_just_pressed("up"):
				if linear_velocity.x < 100:
					linear_velocity.y = -120 * linear_velocity.x / 100 + 20
				else:
					linear_velocity.y = -100
