extends RigidBody2D
class_name Head

enum State {BOUNCE, FLY}
var state: State = State.BOUNCE

func _physics_process(_delta: float) -> void:
	match state:
		State.BOUNCE:
			if global_position.y > 0:
				apply_impulse(Vector2i(0, -50))
			
			if Input.is_action_just_pressed("hit"):
				state = State.FLY
				apply_impulse(Vector2i(1000, -100))
		
		State.FLY:
			apply_force(Vector2i(0, -700))
			
			if Input.is_action_just_pressed("up"):
				if linear_velocity.x < 100:
					linear_velocity.y = -120 * linear_velocity.x / 100 + 20
				else:
					linear_velocity.y = -100
