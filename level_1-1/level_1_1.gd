class_name Level
extends Node2D

var camera: MarkerioCamera = null
@onready var markerio: Markerio = $Markerio
@onready var flag: Flag = $Flag


func _ready():
	camera = MarkerioCamera.new($markerio_spawn_point.position)
	camera.name = "MarkerioCamera"
	markerio.add_child(camera)



func _on_killfloor_body_entered(body):
	if body is Markerio:
		body.die()
	else:
		body.queue_free()



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("duck") and \
				$pipes/Pipe/warp_zone.overlaps_body(markerio) and \
				markerio.is_on_floor():
		enter_secret_level()


var t: Tween
func enter_secret_level():
	markerio.disable_input()
	markerio.set_collision(false)
	markerio.position.x = $pipes/Pipe/warp_zone.global_position.x
	markerio.z_index = -2
	t = get_tree().create_tween()
	t.tween_property(markerio, "position", Vector2(markerio.position.x, markerio.position.y+400), 1)
	t.tween_callback(func():
		print("callbkac that should be kicking off secret level")
		markerio.remove_child(camera)
		camera.queue_free()
		SignalBus.send_signal("secret_level_entrance_triggered")
	)


func exit_warp_pipe():
	print("exiting warp pipe")
	camera = MarkerioCamera.new($markerio_spawn_point.position)
	camera.name = "MarkerioCamera"
	markerio.add_child(camera)
	markerio.disable_input()
	markerio.set_collision(false)
	markerio.z_index = -2
	markerio.position = $pipes/Pipe5/warp_exit.global_position
	markerio.position.y += 512
	t = get_tree().create_tween()
	t.tween_property(markerio, "position", Vector2(markerio.position.x, markerio.position.y-512*2), 1)
	t.tween_callback(func():
			markerio.enable_input()
			markerio.set_collision(true)
			markerio.z_index = 0
			print("pos: ", markerio.position)
			print("pipe pos: ",$pipes/Pipe5/warp_exit.global_position)
	)
