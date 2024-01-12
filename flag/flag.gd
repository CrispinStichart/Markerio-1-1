class_name Flag
extends Node2D

signal markerio_reached_flagpole

var markerio: Markerio
var finished := false


func _ready():
	$AnimationPlayer.animation_finished.connect(func(_animation_name): finished = true)


func _on_area_2d_body_entered(body):
	if body is Markerio:
		$Area2D.set_deferred("monitoring", false)
		markerio = body
		markerio.disable_input()
		$AnimationPlayer.play("flag_drop")


func _process(_delta):
	if not markerio:
		return
	if $AnimationPlayer.is_playing():
		markerio.position = $flag.global_position
		markerio.position.x += 500
		markerio.sprite.flip_h = true
	else:
		markerio.velocity.x = markerio.max_walk_speed
		
	if finished and markerio.position.x > $endpoint.global_position.x:
		markerio.velocity.x = 0
		markerio_reached_flagpole.emit()
