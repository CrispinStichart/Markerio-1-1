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
