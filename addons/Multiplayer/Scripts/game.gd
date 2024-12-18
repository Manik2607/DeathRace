# Autoloaded script/singleton
# Added to the root location
# Manages game states
extends Node3D

const PORT : int = 1784

@onready var main : Node = get_tree().root.get_node("Main")
@onready var players : Node = main.get_node("Players")


var menu : Control = null
var map : Node = null

@export var menu_scene : PackedScene
@export var player_scene : PackedScene
@export var map_scene : PackedScene


func _ready():
	menu = menu_scene.instantiate()
	main.add_child(menu)
	
	# if multiplayer.is_server():
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)

func load_map():
	# Free old stuff.
	if map != null:
		map.queue_free()
	if menu != null:
		menu.queue_free()
	
	# Spawn map.
	map = map_scene.instantiate()
	main.add_child(map)
	
	# if multiplayer.is_server():
	spawn_player(multiplayer.get_unique_id())

func spawn_player(id: int):
	var player : VehicleBody3D = player_scene.instantiate()
	player.peer_id = id
	var pnode = map.get_node("Players").get_children()[players.get_child_count()]
	
	print(pnode.name)
	if pnode:
		player.global_position = pnode.global_position
	players.add_child(player, true) 
	
func remove_player(id: int):
	if not players.has_node(str(id)):
		return
	players.get_node(str(id)).queue_free()
