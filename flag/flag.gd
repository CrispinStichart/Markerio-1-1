class_name Flag
extends Node2D


var markerio: Markerio
var finished := false


func _ready():
	$AnimationPlayer.animation_finished.connect(func(_animation_name): finished = true)


func _on_area_2d_body_entered(body):
	if body is Markerio:
		var mario_y: float = body.global_position.y
		var flag_top: float = $flag_highest_point.global_position.y
		var flag_bottom: float = $flag_lowest_point.global_position.y
		var flag_top_adjusted := flag_top - flag_bottom
		var mario_y_adjusted := mario_y - flag_bottom
		var percent_complete := mario_y_adjusted / flag_top_adjusted
		$Area2D.set_deferred("monitoring", false)
		markerio = body
		markerio.disable_input()
		$AnimationPlayer.play("flag_drop")
		$AnimationPlayer.seek(percent_complete)


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
		SignalBus.send_signal("markerio_reached_flagpole")
