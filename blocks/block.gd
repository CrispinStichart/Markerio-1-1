class_name Block
extends StaticBody2D

var activated := false
var tile_pos: Vector2i = -Vector2i.ONE

var item: Node2D
var secondary_item: Node2D




func activate(_item_wanted: String = ""):
	push_error("Not implemented for ", self)


func produce_coin():
	if item != null:
		item.queue_free()

	item = InstanceManager.create("Coin")
	add_sibling(item)
	item.position = position
	item.position.y -= Constants.BLOCK_SIZE
	var t = get_tree().create_tween()
	t.tween_property(item, "position", item.position - Vector2(0, Constants.BLOCK_SIZE * 3), .5)
	t.tween_callback(item.queue_free)
	item = null

	SignalBus.send_signal("coin_collected")


func produce_item():
	if item == null:
		produce_coin()
		return
	elif "item_name" in item and item.item_name == "coin":
		print("Item is of class 'Coin'")
		# todo: make this do multiple coin logic
		produce_coin()
		return

	add_sibling(item)
	item.process_mode = Node.PROCESS_MODE_DISABLED
	item.position = position
	var t = get_tree().create_tween()
	t.tween_property(item, "position", item.position - Vector2(0, Constants.BLOCK_SIZE), .5)
	t.tween_callback(func(): item.process_mode = Node.PROCESS_MODE_INHERIT)


func add_item(item_to_add: Node2D):
	item = item_to_add
	if "item_name" in item and item.item_name == "Shroom":
		secondary_item = InstanceManager.create("FireFlower")
