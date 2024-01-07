class_name Shroom
extends CharacterBody2D

# Disable the collision if it's not moving. This is so it can slide up out of
# a block.
var direction: int = 0:
	set(new_direction):
		direction = new_direction
		$CollisionShape2D.disabled = direction == 0
var speed = 2


func _ready():
	direction = 0


func _physics_process(_delta):
	if direction == 0:
		return

	if not is_on_floor():
		velocity.y += Game.GRAVITY

	velocity.x = Game.BLOCK_SIZE * speed * direction
	move_and_slide()

	for i in get_slide_collision_count():
		var collision:KinematicCollision2D = get_slide_collision(i)
		if collision.get_angle() != 0:
			direction *= -1



func _on_pickup_area_body_entered(body):
	if body is Markerio:
		body.eat_mushroom()
		queue_free()
