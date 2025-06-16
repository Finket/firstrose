extends Node

@onready var input_system : Node = $"../InputSystem"
@onready var store_system : Node = $"../StoreSystem"

func _ready() -> void:
	input_system.unhandled_input.connect(_handle_click)

func _handle_click(raycast_result : Dictionary, clicker : Node3D) -> void:
	if not raycast_result.collider is ClickableComponent:
		return
	
	if not raycast_result.collider.activatee:
		return
	
	if raycast_result.collider.activatee is StoreComponent:
		store_system.activate(raycast_result.collider.activatee, clicker)
		# TODO: Walk up to the store before activating
