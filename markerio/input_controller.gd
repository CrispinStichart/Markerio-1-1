extends Node

@onready var p:Markerio = get_parent()


func _physics_process(_delta):
	if p.is_on_floor() and p.can_jump and not p.jumping:
		if Input.is_action_just_pressed("jump"):
			p.remaining_jump_height = p.jump_height
			p.can_jump = false
			p.jumping = true

	p.jumping = Input.is_action_pressed("jump")

	if Input.is_action_just_released("jump"):
		p.remaining_jump_height = 0

	var direction := Input.get_axis("left", "right")
	var is_running := Input.is_action_pressed("run")
	var max_speed: float = p.max_run_speed if is_running else p.max_walk_speed

	if direction:
		p.velocity.x += direction * p.acceleration
		p.velocity.x = direction * min(abs(p.velocity.x), max_speed)
	else:
		p.velocity.x = move_toward(p.velocity.x, 0 , p.acceleration)

	if Input.is_action_just_pressed("run"):
		p.throw_fireball()
