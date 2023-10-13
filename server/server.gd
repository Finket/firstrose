extends Control

var multiplayer_peer = ENetMultiplayerPeer.new()

var port : int
var max_players : int

func _ready():
	var args = OS.get_cmdline_user_args()
	
	print(args)
	
	for arg in args:
		var key_value = arg.rsplit("=")
		match key_value[0]:
			"port":
				port = key_value[1].to_int()
			"max-players":
				max_players = key_value[1].to_int()
	
	multiplayer_peer.create_server(port, max_players)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
	print("Server started.")
	load_chat()
	


func add_player_character(id=1):
	await get_tree().create_timer(0.5).timeout
	var character = preload("res://player_character_info.tscn").instantiate()
	var subviewport = $UILayer/Control/SubViewportContainer/SubViewport
	character.name = str(id)
	subviewport.add_child(character)
	print("Player " + character.name + " joined, character added.")

func load_chat():
	var chatbox = preload("res://chat_box_info.tscn").instantiate()
	var control = $UILayer/Control
	control.add_child(chatbox)
	print("Chat loaded.")
