extends Node2D


func _on_area_2d_body_entered(body):
	if body is Markerio:
		body.eat_fire_flower()
		queue_free()

