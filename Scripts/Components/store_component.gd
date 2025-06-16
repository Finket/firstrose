class_name StoreComponent extends Node

# set defaults
var stock : Dictionary = {
	"clothtest" : [0,0], # current, default
	"clothtest2" : [0,0]
}
var restock_rate : int = 8 # per physics tick
var current_tick : int = 0

func _ready() -> void:
	add_to_group(Data.STORE) # register self
