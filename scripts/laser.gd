extends Node2D
class_name Laser

@onready var head: Head = get_tree().get_first_node_in_group("head")
@onready var camera: Camera2D = get_tree().get_first_node_in_group("camera")

var broken: bool = false

signal last

static func instantiate() -> Laser:
	return preload("res://scenes/laser.tscn").instantiate() as Laser

func _physics_process(_delta: float) -> void:
	if head.global_position.x + 10 > global_position.x and not broken:
		last.emit()
		
		if not head.on_fire:
			camera.shake()
			
			head.freeze = true
			head.laser_death_timer.start()
			
			head.sprite.frame = 18
			
			head.anim_tween = create_tween()
			head.anim_tween.set_trans(Tween.TRANS_LINEAR)
			head.anim_tween.tween_property(head.sprite, "frame", 23, 0.35)
		
		broken = true
