extends Node2D


var camera: MarkerioCamera = null
func _ready():
	camera = MarkerioCamera.new($markerio_spawn_point.position)
	$Markerio.add_child(camera)


func _process(_delta):
	$ParallaxBackground.scroll_offset = camera.position
	#for layer:ParallaxLayer in [$ParallaxBackground/sky, $ParallaxBackground/near_background]:
		#layer.motion_offset = ($markerio_spawn_point.position - camera.position) * layer.motion_scale

