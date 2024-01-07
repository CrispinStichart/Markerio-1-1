class_name Coin
extends Node2D

signal coin_collected

var tile_pos: Vector2i = -Vector2i.ONE

func pick_up():
	coin_collected.emit()
	queue_free()


func _on_area_2d_body_entered(body):
	if body is Markerio:
		pick_up()
