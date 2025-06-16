extends Node

# SYSTEM DEPENDENCIES ARE ADJACENT

func _physics_process(_delta: float) -> void:
	var stores : Array[Node] = get_tree().get_nodes_in_group(Data.STORE)
	update_stores(stores)

func update_stores(stores : Array[Node]) -> void:
	for store in stores:
		if not store is StoreComponent:
			continue
		
		store.current_tick += 1
		if store.current_tick > store.restock_rate:
			store.current_tick = 0
			restock_store(store)

func restock_store(component : Node) -> void:
	if not component is StoreComponent:
		return
	
	for item in component.stock.keys():
		var item_stock_data : Array = component.stock[item]
		if item_stock_data[0] < item_stock_data[1]:
			component.stock[item] = [item_stock_data[0] + 1, item_stock_data[1]]
		elif item_stock_data[0] > item_stock_data[1]:
			component.stock[item] = [item_stock_data[0] - 1, item_stock_data[1]]
	pass

func activate(store : StoreComponent) -> void:
	# Todo: open store UI
	print(store.stock)
