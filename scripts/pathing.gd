# Adapted from the Miziziziz tutorial at https://youtu.be/A1xjUuRZmWQ

extends Node3D

var all_points = {}
var astar = null
@export var amap : GridMap

func _ready():
	# Initialize AStar3D and gather cells from GridMap
	astar = AStar3D.new()
	var cells = amap.get_used_cells()
	
	# Loop over cells to create astar graph
	for cell in cells:
		# Get next available index
		var ind = astar.get_available_point_id()
		# Add point to graph
		astar.add_point(ind, to_global(amap.map_to_local(Vector3(cell.x,cell.y,cell.z))))
		all_points[Vector3i(cell)] = ind
	
	# Iterate over all cells again to create appropriate AStar connections
	for cell in cells:
		for x in [-1, 0, 1]:
			for z in [-1, 0, 1]:
				if x==0 and z==0:
					continue
				if Vector3i(x, 0, z) + Vector3i(cell) in all_points:
					var cell1 = all_points[Vector3i(cell)]
					var cell2 = all_points[Vector3i(cell) + Vector3i(x, 0, z)]
					if !astar.are_points_connected(cell1, cell2):
						astar.connect_points(cell1, cell2, true)

func make_path(start, end):
	# if is_multiplayer_authority():
	var map_start = Vector3i(to_global(amap.local_to_map(start)))
	var map_end = Vector3i(to_global(amap.local_to_map(end)))
	var start_ind = 0
	var end_ind = 0
	
	if map_start in all_points:
		start_ind = all_points[map_start]
	else:
		start_ind = astar.get_closest_point(start)
	
	if map_end in all_points:
		end_ind = all_points[map_end]
	else:
		end_ind = astar.get_closest_point(end)
	
	return astar.get_point_path(start_ind, end_ind)
