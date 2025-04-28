extends Node

@onready var world : Node3D = get_tree().root.get_child(0)
@onready var player : Node3D = get_parent()
@export var rotation_speed : float = 0.025
var gridmap : GridMap
var viewport : SubViewport
var camera : Camera3D
var camera_radius : float
const RAY_LENGTH : float = 25

var cell : Vector3i = Vector3i.ZERO
var casting : bool = false

func _physics_process(_delta) -> void:
	if not casting:
		return
	
	move_player()
	casting = false

func _ready() -> void:
	gridmap = world.get_node("GridMap")
	camera = player.get_node("Camera3D")
	camera_radius = player.global_position.distance_to(camera.global_position)
	
	world.get_node("CanvasLayer/Control/CameraView").click_captured.connect(input_event)

func input_event(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("pan"):
		rotate_camera(event)
	
	if event.is_action_pressed("select"):
		var space_state : PhysicsDirectSpaceState3D = world.get_world_3d().get_direct_space_state()
		var from : Vector3 = camera.project_ray_origin(event.position)
		var to : Vector3 = from + camera.project_ray_normal(event.position) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(from, to, 0xFFFFFFFF, [self])
		var result = space_state.intersect_ray(query)
		
		if result:
			cell = gridmap.local_to_map(result.position.round())
			casting = true

func move_player():
	var player_tile_id : int = world.coordinates_to_id(player.real_position)
	var tile_id : int = world.coordinates_to_id(Vector2i(cell.x, cell.z))
	
	var id_path : Array = world.astar.get_id_path(player_tile_id, tile_id, true)
	var path : Array = id_path.map(world.id_to_coordinates)
	path.pop_front()
	
	player.path = path

func rotate_camera(event: InputEventMouseMotion) -> void:
	player.rotate(Vector3.UP, -event.relative.x * rotation_speed / camera_radius)
	# player.rotate(Vector3.FORWARD, event.relative.y * rotation_speed / camera_radius)
