extends Node

# This is just an example for communicating with this server. Later,
# levels will obviously be stored on a per-player basis in a more complex way.
var player_data

func _ready():
	var file = FileAccess.open("res://PlayerData.json", FileAccess.READ)
	var file_data = file.get_as_text()
	player_data = JSON.parse_string(file_data)
	file.close()
