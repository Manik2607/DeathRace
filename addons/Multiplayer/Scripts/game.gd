# Autoloaded script/singleton
# Added to the root location
# Manages game states
extends Node3D

const PORT: int = 1784

@onready var main: Node = get_tree().root.get_node("Main")
@onready var players: Node = main.get_node("Players")


var menu: Control = null
var map: Node = null

@export var menu_scene: PackedScene
@export var player_scene: PackedScene
@export var map_scene: PackedScene
@export var lobby_scene: PackedScene

var playersData = {}


func _ready():
	pass
	#menu = menu_scene.instantiate()
	#main.add_child(menu)
	

	#multiplayer.peer_connected.connect(spawn_player)
	#multiplayer.peer_disconnected.connect(remove_player)
	#multiplayer.connected_to_server.connect(conected_to_server)

func load_map():
	# Free old stuff.
	if map != null:
		map.queue_free()
	if menu != null:
		menu.queue_free()
	
	# Spawn map.
	map = lobby_scene.instantiate()
	main.add_child(map)
	

	

@rpc("any_peer")
func sendPlayerInfo(name,id):
	if !playersData.has(id):
		playersData[id] ={
			"id":id,
			"name":name
		}
	if multiplayer.is_server():
		for i in playersData:
			sendPlayerInfo.rpc(playersData[i].name,i)
	

func spawn_player(id: int):
	var player: VehicleBody3D = player_scene.instantiate()
	player.peer_id = id
	player.global_position = Vector3(randf(),randf(),randf())*50
	players.add_child(player, true)

func remove_player(id: int):
	if not players.has_node(str(id)):
		return
	players.get_node(str(id)).queue_free()
	
@rpc("authority", "call_local", "reliable")
func load_game():
	if map:
		map.queue_free()
	map = map_scene.instantiate()
	main.add_child(map)

@rpc("authority", "call_local", "reliable")
func restart_race():
	var index = 0
	for p in playersData:
		var pos = map.get_node("Players").get_child(index).global_position
		players.get_node(str(playersData[p].id)).set_pos.rpc(pos)
		index += 1
