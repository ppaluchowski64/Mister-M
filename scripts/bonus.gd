extends Window

@onready var label: Label = $Control/Label
@onready var particles: CPUParticles2D = $Control/Control/CPUParticles2D

func _on_texture_button_pressed() -> void:
	label.text = "CORRECT ANSWER!!!"
	particles.emitting = true
	
	await get_tree().create_timer(4).timeout
	hide()

func _on_bonus_button_pressed() -> void:
	show()
