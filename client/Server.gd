# https://youtu.be/lnFN6YabFKg

extends Node

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 13589


func _on_join_pressed():
	network.create_client(ip, port)
	multiplayer.set_multiplayer_peer(network)
	
	multiplayer.connect("connection_failed", _on_connection_failed)
	multiplayer.connect("connected_to_server", _on_connection_succeeded)

func _on_connection_failed():
	print("Failed to connect")

func _on_connection_succeeded():
	print("Connection successful")

@rpc("any_peer", "reliable")
func fetch_level(level_name, requester):
	# print("fetching test level from server...")
	rpc_id(1, "fetch_level", level_name, requester)

@rpc("authority", "reliable")
func return_level(level, requester):
	instance_from_id(requester).set_level(level)
