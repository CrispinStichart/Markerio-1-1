extends InputController

const _BUFFER_TIME: float = .1
var _jump_buffer: float = 0

func get_direction() -> float:
	return Input.get_axis("left", "right")


func wants_run() -> bool:
	return Input.is_action_pressed("run")


func wants_fireball() -> bool:
	return Input.is_action_just_pressed("run")


func wants_jump() -> bool:
	if _jump_buffer > 0:
		_jump_buffer = 0
		return true
	return false


func jump_released() -> bool:
	return Input.is_action_just_released("jump")


func _physics_process(delta):
	_jump_buffer -= delta
	if Input.is_action_just_pressed("jump"):
		_jump_buffer = _BUFFER_TIME
