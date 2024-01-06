extends Node2D


func _process(_delta):
	$ParallaxBackground.scroll_offset = abs(Vector2(-Game.BLOCK_SIZE*4, 0) - $Markerio/Camera.position)
	for layer:ParallaxLayer in [$ParallaxBackground/sky, $ParallaxBackground/near_background]:
		layer.motion_offset = -abs(Vector2(-Game.BLOCK_SIZE*4, 0) - $Markerio/Camera.position) * layer.motion_scale * 10

