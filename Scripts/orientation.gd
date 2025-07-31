extends Node

# TODO: simply ECS this, storing sprite(s) on component

@onready var camera : Camera3D = $"../SubViewport/Player/Camera3D"
@onready var sprite : Sprite3D = $Sprite3D

var direction : Vector2 = Vector2.DOWN

func _process(_delta: float) -> void:
	# TODO: track direction based on movement
	direction = Vector2.DOWN
	camera.orient_sprite(sprite, direction)
