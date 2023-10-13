extends Node3D

var multiplayer_peer = ENetMultiplayerPeer.new()

@onready var menu = $UILayer/Control/StartMenu

#func _ready():
#	get_tree().set_auto_accept_quit(false)

func _on_join_pressed():
	var port = str($UILayer/Control/StartMenu/PortNumber.text).to_int()
	multiplayer_peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false

#func _on_host_pressed():
#	var port = str($UILayer/Control/StartMenu/PortNumber.text).to_int()
#	multiplayer_peer.create_server(port)
#	multiplayer.multiplayer_peer = multiplayer_peer
#	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
#	menu.visible = false
#	add_player_character()

#func add_player_character(id=1):
#	var character = preload("res://player_character.tscn").instantiate()
#	var subviewport = $UILayer/Control/SubViewportContainer/SubViewport
#	character.name = str(id)
#	subviewport.add_child(character)
#	await get_tree().create_timer(0.5).timeout
#
#func _notification(what):
#	if what == NOTIFICATION_WM_CLOSE_REQUEST:
#		print('here')
#		var peer = multiplayer_peer.get_unique_id()
#		multiplayer_peer.disconnect_peer(peer)
#		get_tree().quit()
