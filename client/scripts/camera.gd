extends Camera3D

@onready var synchronizer = get_node("../../MultiplayerSynchronizer")

# The parent target to orbit around
@onready var target : CharacterBody3D = get_node("../").get_parent()
# The rotation speed
var rotation_speed : float = 0.025
# The current horizontal rotation angle
var horizontal_rotation : float = 0.0
# The radius between camera and character
var radius : float = 4.0
# Size of a grid cell
var cell_size : float = 2.0

# mouse raycast length
const ray_length = 1000
# The game board containing the pathing script
@onready var board : Node3D = get_node("/root/World/Board")
# Whether or not the target should be moving
# var moving_along_path : bool = false

func _ready():
	print(synchronizer)
	synchronizer.set_multiplayer_authority(str(target.name).to_int())
	print(synchronizer.is_multiplayer_authority())
	current = synchronizer.is_multiplayer_authority()
	# await get_tree().create_timer(1).timeout
	look_at_target()
	
	# print(board)

func _input(event):
	if synchronizer.is_multiplayer_authority():
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE) and event is InputEventMouseMotion:
			rotate_camera(event)
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and event is InputEventMouseButton:
			move_target()

func _process(_delta):
	look_at_target()

func rotate_camera(event):
	# -event.relative.x is the horizontal motion of the mouse
	# calculate angle and rotate
	horizontal_rotation = -event.relative.x * rotation_speed / radius
	target.rotate(Vector3(0, 1, 0), horizontal_rotation)

func look_at_target():
	# Point the camera at the target
	var target_feet = Vector3(
		target.position.x, 
		target.position.y - target.scale.y / 2, 
		target.position.z)
	
	look_at(target_feet)

func move_target():
	# Get the mouse position in screen coordinates
	var mouse_pos = get_viewport().get_mouse_position()

	# Perform a raycast to find the 3D point on the ground where the player clicked
	var ray_origin = project_ray_origin(mouse_pos)
	var ray_destination = ray_origin + project_ray_normal(mouse_pos) * ray_length
	var space_state = get_world_3d().direct_space_state
	var ray_parameters = PhysicsRayQueryParameters3D.create(ray_origin, ray_destination)
	
	var raycast_result = space_state.intersect_ray(ray_parameters)
	
	if raycast_result:
		# Extract the hit point and update the character's position
		var hit_point = raycast_result.position
		
		# Snap to grid cell position
		var grid_cell_x = int(round(hit_point.x / cell_size) * cell_size) 
		var grid_cell_z = int(round(hit_point.z / cell_size) * cell_size) 
		
		# Note: y-height is preserved.
		# Teleport to clicked location
		# target.position.x = grid_cell_x
		# target.position.z = grid_cell_z
		
		# Pathfind to clicked location using AStar
		var path = board.make_path(target.position, Vector3(grid_cell_x, target.position.y, grid_cell_z))
		if path.size() > 0:
			target.move_to(path)
		else:
			# handle the case where no path is found
			pass
			
