extends Node2D

signal markerio_reached_flagpole

var markerio: Markerio

func _on_area_2d_body_entered(body):
	if body is Markerio:
		markerio = body
		markerio_reached_flagpole.emit()
		$AnimationPlayer.play("flag_drop")


func _process(_delta):
	if $AnimationPlayer.is_playing():
		markerio.position = $flag.global_position
