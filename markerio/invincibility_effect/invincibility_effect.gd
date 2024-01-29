extends GPUParticles2D

@onready var markerio: Markerio = get_parent()
@onready var markerio_sprite = markerio.get_node("Sprite2D")
const COLOR_START = Color(2, 2, 0, 1)
const COLOR_END = Color(2, 1, 0, 1)
var flash_duration: float = .1
var t: Tween



func _process(_delta):
	emitting = markerio.has_star
	visible = markerio.has_star

	if emitting and not t:
		t = create_tween()
		t.tween_property(markerio_sprite, "self_modulate", COLOR_END, flash_duration)
		t.tween_property(markerio_sprite, "self_modulate", COLOR_START, flash_duration)
		t.set_loops()
	elif not emitting:
		if t:
			t.stop()
		t = null
		markerio_sprite.self_modulate = Color.WHITE
