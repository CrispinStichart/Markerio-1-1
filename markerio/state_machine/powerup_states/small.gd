extends MarkerioState

func enter():
	markerio.get_node("small_collider").set_deferred("disabled", false)
	markerio.get_node("big_collider").set_deferred("disabled", true)

	markerio.idle_animation = "idle_small"
	markerio.move_animation = "run_small"

	markerio.get_node("block_detector").position.y = -328

