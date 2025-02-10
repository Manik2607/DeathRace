extends Node3D




func _on_area_3d_body_entered(body:Node3D):
	if body.has_method("win"):
		body.win()
		$Control/Panel/Label.text = body.get_node("Label3D").text + " is the WINNER!!"
		$Control.show()
		#$Control/Button.visible = multiplayer.is_server()
			
		


func _on_button_pressed():
	GameManager.restart_race()


@rpc("any_peer","call_local","reliable")
func reset():
	$Control.hide()


func _on_back_pressed():
	reset.rpc()
