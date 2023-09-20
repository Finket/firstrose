# Adapted from a tutorial by DitzyNinja's Godojo
# https://youtu.be/d8QpnamQq1A
# https://youtu.be/3xgDU4gRLps
# https://github.com/TheGodojo/Godot-4-Networking-Demonstration-Complete

extends Node3D

var cursor = load("res://sprites/cursor.png")

# This object handles networking
var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 10808
const ADDRESS = "localhost"

var connected_peer_ids = []
var local_player_character

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(cursor)
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_IBEAM)
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_POINTING_HAND)

func _on_host_pressed():
	$UILayer/Control/NetworkInfo/NetworkSideDisplay.text = "Server"
	$UILayer/Control/StartMenu.visible = false
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	$UILayer/Control/NetworkInfo/UniquePeerID.text = str(multiplayer.get_unique_id())
	
	# Add a player character for the host. The server's peer id is 1.
	add_player_character(1)
	
	multiplayer_peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_player_character", connected_peer_ids)
			add_player_character(new_peer_id)
	)

func _on_join_pressed():
	$UILayer/Control/NetworkInfo/NetworkSideDisplay.text = "Client"
	$UILayer/Control/StartMenu.visible = false
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	$UILayer/Control/NetworkInfo/UniquePeerID.text = str(multiplayer.get_unique_id())

func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://player_character.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	get_tree().get_root().get_node("World/UILayer/Control/SubViewportContainer/SubViewport/Board").add_child(player_character)
	if peer_id == multiplayer.get_unique_id():
		local_player_character = player_character

@rpc
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)

@rpc
func add_previously_connected_player_character(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)

# Replace this with my own textbox and chat mechanic. 
# For now just use peer ID instead of a display name.
func _on_message_input_text_submitted(new_text):
	local_player_character.rpc("display_message", new_text)
	$MessageInput.text = ""
	$MessageInput.release_focus()
