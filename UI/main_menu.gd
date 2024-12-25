extends Control

@export var main_scene:PackedScene
@export var test_scenes_0:PackedScene
@export var test_scenes_1:PackedScene
@export var menu_scene:PackedScene





func _on_button_button_down():
	get_tree().change_scene_to_packed(main_scene)


func _on_test_1_button_down():
	get_tree().change_scene_to_packed(test_scenes_0)


func _on_test_2_button_down():
	get_tree().change_scene_to_packed(test_scenes_1)


func _on_multiplayer_pressed():
	get_tree().change_scene_to_packed(menu_scene)


func _on_settings_pressed():
	$Settings.show()
