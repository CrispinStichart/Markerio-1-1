class_name GameUI
extends CanvasGroup

var t: Tween

func _ready():
	$Control/Wasted.visible = false


func show_death_screen(callback: Callable):
	$Control/Wasted.visible = true
	t = create_tween()
	t.tween_property($Control/Wasted, "visible", false, 2)
	t.tween_callback(callback)
