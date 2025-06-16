class_name ClickableComponent extends StaticBody3D

var activatee : Node = null

func _ready() -> void:
	add_to_group(Data.CLICKABLE)
