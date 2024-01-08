extends MarkerioState

func enter():
	markerio.get_node("small_collider").set_deferred("disabled", true)
	markerio.get_node("big_collider").set_deferred("disabled", false)

	markerio.idle_animation = "idle_flower"
	markerio.move_animation = "run_flower"

	markerio.get_node("block_detector").position.y = -640
