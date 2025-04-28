extends Node3D

@onready var gridmap : GridMap = $GridMap
var astar : AStar2D
var coordinates_to_id_map : Dictionary = { }
var id_to_coordinates_map : Dictionary = { }
var next_id : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_level()

func build_level() -> void:
	astar = AStar2D.new()
	
	for tile in gridmap.get_used_cells():
		var tile_coordinates : Vector2i = Vector2i(tile.x, tile.z)
		var tile_id = register_coordinates(tile_coordinates)
		astar.add_point(tile_id, tile_coordinates)
	
	connect_neighbors()

func connect_neighbors() -> void:
	for tile in gridmap.get_used_cells():
		var tile_coordinates : Vector2i = Vector2i(tile.x, tile.z)
		var tile_id = coordinates_to_id_map[tile_coordinates]
		var neighbors : Array[Vector2i] = [
			tile_coordinates + Vector2i(1, 0),
			tile_coordinates + Vector2i(-1, 0),
			tile_coordinates + Vector2i(0, 1),
			tile_coordinates + Vector2i(0, -1)
		]
		for neighbor in neighbors:
			if not coordinates_to_id_map.has(neighbor):
				continue
			
			var neighbor_id : int = coordinates_to_id_map[neighbor]
			if not astar.are_points_connected(tile_id, neighbor_id):
				astar.connect_points(tile_id, neighbor_id)

func register_coordinates(coordinates: Vector2i) -> int:
	if coordinates in coordinates_to_id_map:
		return coordinates_to_id_map[coordinates]
	
	var tile_id : int = next_id
	next_id += 1
	
	coordinates_to_id_map[coordinates] = tile_id
	id_to_coordinates_map[tile_id] = coordinates
	return tile_id

func coordinates_to_id(coordinates: Vector2i) -> int:
	return coordinates_to_id_map[coordinates]

func id_to_coordinates(tile_id: int) -> Vector2i:
	return id_to_coordinates_map[tile_id]

func check_connection(from_id: int, to_id: int) -> bool:
	return astar.are_points_connected(from_id, to_id)
