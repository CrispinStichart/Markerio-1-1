extends Node

@onready var p:Markerio = get_parent()




#func _ready():
	#assert("acceleration" in p)
	#assert("max_walk_speed" in p)
	#assert("max_run_speed" in p)
	#assert("jump_height" in p)


func _physics_process(delta):
	if p.is_on_floor():
		p.can_jump = true
		p.jumping = false
		p.remaining_jump_height = 0
	elif not p.is_on_floor() and p.remaining_jump_height <= 0:
		p.velocity.y += Game.GRAVITY
		p.velocity.y = min(p.velocity.y, p.jump_speed)

	if p.is_on_floor() and p.can_jump and not p.jumping:
		if Input.is_action_just_pressed("jump"):
			p.remaining_jump_height = p.jump_height
			p.can_jump = false
			p.jumping = true

	p.jumping = Input.is_action_pressed("jump")

	if Input.is_action_just_released("jump"):
		p.remaining_jump_height = 0

	if p.jumping and p.remaining_jump_height > 0:
		var jump_change: float = p.jump_speed
		p.remaining_jump_height -= jump_change * delta
		p.velocity.y = -jump_change



	var direction := Input.get_axis("left", "right")
	var is_running := Input.is_action_pressed("run")
	var max_speed: float = p.max_run_speed if is_running else p.max_walk_speed
	if direction:
		p.velocity.x += direction * p.acceleration
		p.velocity.x = direction * min(abs(p.velocity.x), max_speed)
	else:
		p.velocity.x = move_toward(p.velocity.x, 0 , p.acceleration)

	p.move_and_slide()


