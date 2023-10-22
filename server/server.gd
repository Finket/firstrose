# https://youtu.be/lnFN6YabFKg

extends Node

var network = ENetMultiplayerPeer.new()
var gateway = SceneMultiplayer.new()
var port = 1707
var max_players = 40


func _ready():
	start_server()

func start_server():
	network.create_server(port, max_players)
	# get_tree().set_multiplayer(gateway, self.get_path())
	multiplayer.set_multiplayer_peer(network)
	print("Server started")
	
	network.connect("peer_connected", _peer_connected)
	network.connect("peer_disconnected", _peer_disconnected)

func _peer_connected(player_id):
	print("User " + str(player_id) + " Connected")

func _peer_disconnected(player_id):
	print("User " + str(player_id) + " Disconnected")

@rpc("any_peer", "reliable")
func fetch_level(level_name, requester):
	var player_id = multiplayer.get_remote_sender_id()
	var level = ServerData.player_data["Player Levels"][level_name]
	print("Sending " + str(level) + " to player " + str(player_id))
	return_level(level, requester, player_id)

@rpc("authority", "reliable")
func return_level(level, requester, player_id):
	rpc_id(player_id, "return_level", level, requester)
