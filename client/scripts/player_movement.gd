# code adapted from tutorial by Miziziziz: https://youtu.be/A1xjUuRZmWQ

extends CharacterBody3D

var path = []
var path_ind = 0
const move_speed = 4
var level

@onready var server = get_tree().root.get_child(0)

func _enter_tree():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

#func _ready():
#	synchronizer.set_multiplayer_authority(str(name).to_int())
#	set_name.call_deferred(str(get_multiplayer_authority()))
	# add_to_group('units')

# REMOVE THIS LATER
func _on_join_pressed():
	# this is just an example server call for now to get some data
	await get_tree().create_timer(0.5).timeout
	server.fetch_level("Test", get_instance_id())

func _physics_process(_delta):
	# if is_multiplayer_authority():
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			set_velocity(move_vec.normalized() * move_speed)
			#rpc("remote_set_position", global_position)
			move_and_slide()

func set_level(new_level):
	level = new_level
	print("Level set to " + str(level))

func move_to(new_path):
	# if is_multiplayer_authority():
	path = new_path
	path_ind = 0

#@rpc("unreliable")
#func remote_set_position(authority_position):
#	global_position = authority_position
#
#@rpc("authority", "call_local", "reliable", 1)
#func display_message(message):
#	$Message.text = str(message)
