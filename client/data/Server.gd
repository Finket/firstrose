# https://youtu.be/lnFN6YabFKg

extends Node

var network = ENetMultiplayerPeer.new()
var ip = "127.0.0.1"
var port = 1707


func _on_join_pressed():
	network.create_client(ip, port)
	multiplayer.set_multiplayer_peer(network)
	
	multiplayer.connect("connection_failed", _on_connection_failed)
	multiplayer.connect("connected_to_server", _on_connection_succeeded)

func _on_connection_failed():
	print("Failed to connect")

func _on_connection_succeeded():
	print("Connection successful")
