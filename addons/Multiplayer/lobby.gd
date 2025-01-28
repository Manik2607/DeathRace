extends Node3D


func _ready():
	if !is_multiplayer_authority():
		$Control.hide()

func _on_start_pressed():
	GameManager.load_game.rpc()
