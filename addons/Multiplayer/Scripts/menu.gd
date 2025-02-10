extends Control



func _ready():
	multiplayer.connected_to_server.connect(conected_to_server)
	if OS.get_name() == "Android":
		for i in IP.get_local_addresses():
			$ip_Label.text+=i+"\n"
	else:
		$ip_Label.text+= IP.get_local_addresses()[5]


func conected_to_server():
	print("conected_to_server")
	GameManager.sendPlayerInfo.rpc_id(1,$VBoxContainer/name/LineEdit.text,multiplayer.get_unique_id())


func _on_create_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(GameManager.PORT)
	multiplayer.multiplayer_peer = peer
	GameManager.sendPlayerInfo($VBoxContainer/name/LineEdit.text,multiplayer.get_unique_id())
	GameManager.load_map()
	hide()



func _on_connect_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client($VBoxContainer/ipIn.text, GameManager.PORT)
	multiplayer.multiplayer_peer = peer
	GameManager.load_map()
	hide()
	
