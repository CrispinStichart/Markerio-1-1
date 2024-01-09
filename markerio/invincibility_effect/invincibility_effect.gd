extends GPUParticles2D

@onready var markerio: Markerio = get_parent()


func _process(delta):
	emitting = markerio.has_star
