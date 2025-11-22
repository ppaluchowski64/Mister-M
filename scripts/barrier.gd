extends Node2D
class_name Barrier

@onready var head: Head = get_tree().get_first_node_in_group("head")
@onready var camera: Camera2D = get_tree().get_first_node_in_group("camera")

@onready var polygon_mask: Polygon2D = $PolygonMask
@onready var sprite: Sprite2D = $PolygonMask/Sprite2D
@onready var particles: CPUParticles2D = $CPUParticles2D

var broken: bool = false
var sunk: bool = false

static func instantiate() -> Barrier:
	return preload("res://scenes/barrier.tscn").instantiate() as Barrier

func _ready() -> void:
	var weak_point: WeakPoint = WeakPoint.instantiate()
	weak_point.position = Vector2(-10, randf_range(-30, 30))
	add_child(weak_point)

func _physics_process(_delta: float) -> void:
	if head.global_position.x + 10 > global_position.x and not broken:
		polygon_mask.color.a = 1
		polygon_mask.clip_children = CanvasItem.CLIP_CHILDREN_ONLY
		
		sprite.global_position.y = -head.global_position.y - 13.5
		polygon_mask.global_position.y = head.global_position.y - 13.5
		particles.global_position.y = head.global_position.y - 13.5 + 12
		
		particles.emitting = true
		broken = true
		
		if not sunk:
			head.apply_impulse(Vector2(-20, 0))
			camera.shake()
