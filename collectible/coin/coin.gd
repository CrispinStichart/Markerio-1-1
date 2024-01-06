class_name Coin
extends Node2D

signal coin_collected

func pick_up():
	coin_collected.emit()
	queue_free()


func _on_area_2d_body_entered(body):
	if body is Markerio:
		pick_up()
