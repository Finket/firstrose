# code adapted from tutorial by Miziziziz: https://youtu.be/A1xjUuRZmWQ

extends CharacterBody3D

var path = []
var path_ind = 0
const move_speed = 4

func _enter_tree():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

#func _ready():
#	synchronizer.set_multiplayer_authority(str(name).to_int())
#	set_name.call_deferred(str(get_multiplayer_authority()))
	# add_to_group('units')

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
