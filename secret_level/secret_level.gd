class_name SecretLevel
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"background (only in editor)".visible = false
	var new_transform:Transform2D = Transform2D(ViewportGlobal.transform)

	new_transform.origin = Vector2.ZERO
	new_transform = new_transform.scaled(Vector2.ONE * .2)
	get_viewport().canvas_transform = new_transform


func _process(_delta):
	var new_transform:Transform2D = Transform2D(ViewportGlobal.transform)

	new_transform.origin = Vector2.ZERO
	new_transform = new_transform.scaled(Vector2.ONE * .25)
	get_viewport().canvas_transform = new_transform


# There was a weird glitch where this callback was being called twice
# in a row. Not sure why, so this is just a hacky workaround.
var left := false
func _on_leave_area_body_entered(_body):
	if left:
		return
	left = true
	SignalBus.send_signal("secret_level_exit_triggered")

