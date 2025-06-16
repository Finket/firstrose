extends Node

# COMPONENTS
@onready var dialog_component : Node = $DialogComponent
@onready var store_component : StoreComponent = $StoreComponent
@onready var clickable_component : ClickableComponent = $ClickableComponent

# Change component defaults to match this entity
func _ready() -> void:
	store_component.stock = {
		"clothtest" : [1,1],
		"clothtest2" : [1,2]
	}
	
	clickable_component.activatee = store_component
