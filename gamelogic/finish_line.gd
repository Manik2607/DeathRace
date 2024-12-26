extends Node3D




func _on_area_3d_body_entered(body:Node3D):
	if body.has_method("win"):
		body.win()
		$Control/Panel/Label.text = body.name
		$Control.show()
		


func _on_button_pressed():
	get_tree().reload_current_scene()
	$Control.hide()
