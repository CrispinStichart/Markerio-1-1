class_name Level
extends Node2D

signal secret_area_entered
signal secret_area_left

var camera: MarkerioCamera = null
@onready var markerio: Markerio = $Markerio
@onready var flag: Flag = $Flag


func _ready():
	camera = MarkerioCamera.new($markerio_spawn_point.position)
	camera.name = "MarkerioCamera"
	markerio.add_child(camera)

	print("called level's read()")



func _on_killfloor_body_entered(body):
	if body is Markerio:
		body.die()
	else:
		body.queue_free()



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("duck") and \
				$pipes/Pipe/warp_zone.overlaps_body(markerio) and \
				markerio.is_on_floor():
		enter_secret_area()


var t: Tween
func enter_secret_area():
	markerio.disable_input()
	markerio.set_collision(false)
	markerio.position.x = $pipes/Pipe/warp_zone.global_position.x
	markerio.z_index = -2
	t = get_tree().create_tween()
	t.tween_property(markerio, "position", Vector2(markerio.position.x, markerio.position.y+400), 1)
	t.tween_callback(func(): secret_area_entered.emit())


func exit_warp_pipe():
	print("exiting warp pipe")
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

#func teleport_mario_to_secret_area() -> void:
	#markerio.position = $secret_area/entrance.global_position
	#t = get_tree().create_tween()
	#t.tween_property(markerio, "position", Vector2(markerio.position.x, markerio.position.y + 256), 1)
	#t.tween_callback(func():
		#markerio.set_collision(true)
		#markerio.enable_input()
		#markerio.z_index = 0
		#camera.reparent($secret_area))
