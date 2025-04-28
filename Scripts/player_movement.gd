extends Node3D

# @export var movement_speed : float = 1.0 # maybe 2.0 if running, eventually
@onready var camera : Camera3D = $Camera3D
var path : Array = [ ]
var previous_tile : Vector2i = Vector2i.ZERO
var step : Vector2i
var clock : float = 0

var real_position : Vector2i = Vector2i.ZERO # only this gets sent to server
var direction : Vector2 = Vector2.DOWN
var real_direction : Vector2 = Vector2.DOWN # only this gets sent to server

const TICKRATE : float = 0.5

func _process(delta: float) -> void:
	if global_position.x == real_position.x && global_position.z == real_position.y:
		return
	
	if Vector2(global_position.x, global_position.z).distance_to(real_position) < 0.001:
		global_position.x = real_position.x
		global_position.z = real_position.y
		return
	
	direction = (Vector2(real_position) - Vector2(global_position.x, global_position.z)).normalized()
	
	global_position.x += delta * 1/TICKRATE * direction.x
	global_position.z += delta * 1/TICKRATE * direction.y

func _physics_process(delta: float) -> void:
	if path.size() == 0:
		previous_tile = real_position
		return
	
	clock += delta
	if clock >= TICKRATE:
		clock = 0
		
		real_position = path[0]
		real_direction = direction.normalized()
		path.pop_front()
