extends Node2D

signal markerio_reached_flagpole

var markerio: Markerio
var finished := false


func _ready():
	$AnimationPlayer.animation_finished.connect(func(_animation_name):
		finished = true
		print("lol"))


func _on_area_2d_body_entered(body):
	if body is Markerio:
		$Area2D.set_deferred("monitoring", false)
		markerio = body
		markerio_reached_flagpole.emit()
		markerio.remove_child(markerio.get_node("input_controller"))
		$AnimationPlayer.play("flag_drop")


func _process(_delta):
	if $AnimationPlayer.is_playing():
		markerio.position = $flag.global_position
	if finished and markerio.position.x > position.x + get_viewport().size.x / Game.CAMERA_SCALE / 2:
		markerio.velocity.x = 0
