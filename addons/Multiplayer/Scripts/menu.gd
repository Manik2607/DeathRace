
extends Control



func _ready():
	for i in IP.get_local_addresses():
		$ip_Label.text+=i+"\n"
	

func _on_create_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(GameManager.PORT)
	multiplayer.multiplayer_peer = peer
	GameManager.load_map()



func _on_connect_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client($VBoxContainer/ipIn.text, GameManager.PORT)
	multiplayer.multiplayer_peer = peer
	GameManager.load_map()
