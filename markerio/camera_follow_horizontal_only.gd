class_name MarkerioCamera
extends Node2D

@export var height: float = -Constants.BLOCK_SIZE*5
#var viewport: Viewport = get_view
@export var scale_factor: float = Constants.CAMERA_SCALE


@export var level_start: Vector2


func _init(level_start_: Vector2 = Vector2.ZERO):
	if level_start:
		level_start = level_start_


func _ready():
	var new_transform:Transform2D = Transform2D(ViewportGlobal.transform)
	# The ground is two tiles high. We adjust the camera so that 1.5 tiles are visible.
	var scaled_height := ViewportGlobal.size.y / scale_factor
	new_transform.origin = Vector2(0, scaled_height + Constants.BLOCK_SIZE / 2)

	# We "zoom out".
	new_transform = new_transform.scaled(Vector2.ONE * scale_factor)
	get_viewport().canvas_transform = new_transform



func _process(_delta):
	var new_transform:Transform2D = get_viewport().canvas_transform
	new_transform.origin.x = max(get_parent().position.x, level_start.x) * -scale_factor + 512

	get_viewport().canvas_transform = new_transform

