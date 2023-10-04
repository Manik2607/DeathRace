extends CanvasLayer


func _ready():
	pass
#	$"Panel/VBoxContainer/EnginForce/Control/HSlider".value = get_parent().engine_force_value
#	$Panel/VBoxContainer/Stearspeed/Control/HSlider.value = get_parent().STEER_SPEED

func _on_button_pressed():
	$Panel.show()

func _on_button_button_down():
	$Panel.hide()
