class_name Block
extends StaticBody2D

var coin_scene = preload("res://collectible/coin/coin.tscn")
var mushroom_scene = preload("res://collectible/shroom/shroom.tscn")

var activated := false
var tile_pos: Vector2i = -Vector2i.ONE

func activate():
	push_error("Not implemented for ", self)


func produce_coin():
	var coin:Coin = coin_scene.instantiate()
	add_sibling(coin)
	coin.position = position
	coin.position.y -= Game.BLOCK_SIZE
	var t = get_tree().create_tween()
	t.tween_property(coin, "position", coin.position - Vector2(0, Game.BLOCK_SIZE * 3), .5)
	t.tween_callback(coin.queue_free)


func produce_mushroom():
	var shroom:Shroom = mushroom_scene.instantiate()
	add_sibling(shroom)
	shroom.position = position
	shroom.speed = 0
	var t = get_tree().create_tween()
	t.tween_property(shroom, "position", shroom.position - Vector2(0, Game.BLOCK_SIZE), .5)
	t.tween_callback(func(): shroom.fully_extruded())
