extends Camera3D

# TODO: generalize to work for all players
@onready var player : Node3D = get_parent()
@onready var sprite : Sprite3D = player.get_node("Sprite3D")

func _process(_delta: float) -> void:
	look_at(player.get_position())
	
	var camera_angle : Vector3 = get_global_transform().basis.z
	var camera_direction : Vector2 = Vector2(camera_angle.x, camera_angle.z).normalized()
	
	var angle : float = camera_direction.angle_to(player.direction) * 180 / PI + 180
	sprite.frame = angle_to_sprite(angle)

func angle_to_sprite(angle: float) -> int:
	if 80 <= angle && angle < 150:
		return 2
	elif 150 <= angle && angle < 210:
		return 1
	elif 210 <= angle && angle < 280:
		return 0
	elif 30 <= angle && angle < 80:
		return 5
	elif 280 <= angle && angle < 330:
		return 3
	else:
		return 4
