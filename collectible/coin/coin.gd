class_name Coin
extends Node2D

var tile_pos: Vector2i = -Vector2i.ONE

func pick_up():
	SignalBus.send_signal("coin_collected")
	queue_free()


func _on_area_2d_body_entered(body):
	if body is Markerio:
		pick_up()
