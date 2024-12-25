extends CanvasLayer


func _ready():
	pass
#	$"Panel/VBoxContainer/EnginForce/Control/HSlider".value = get_parent().engine_force_value
#	$Panel/VBoxContainer/Stearspeed/Control/HSlider.value = get_parent().STEER_SPEED



func _on_settings_toggled(toggled_on):
	$Panel.visible = !$Panel.visible
