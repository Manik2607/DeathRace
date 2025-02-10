extends Node3D

@export var PlayerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.playersData:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.playersData[i].id)
		currentPlayer.peer_id = str(GameManager.playersData[i].id)
		currentPlayer.get_node("Label3D").text = GameManager.playersData[i].name
		GameManager.players.add_child(currentPlayer)
		for spawn in get_children():
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1
