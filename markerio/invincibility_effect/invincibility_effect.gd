extends GPUParticles2D

@onready var markerio: Markerio = get_parent()


func _process(_delta):
	emitting = markerio.has_star
