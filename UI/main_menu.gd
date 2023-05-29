extends Control

@export var main_scene:PackedScene



func _on_button_button_down():
	get_tree().change_scene_to_packed(main_scene)
