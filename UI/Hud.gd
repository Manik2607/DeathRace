extends CanvasLayer


func _ready():
	pass
#	$"Panel/VBoxContainer/EnginForce/Control/HSlider".value = get_parent().engine_force_value
#	$Panel/VBoxContainer/Stearspeed/Control/HSlider.value = get_parent().STEER_SPEED




func _on_settings_settings_menu_closed():
	$Settings.hide()


func _on_settings_pressed():
	$Settings.show() # Replace with function body.
