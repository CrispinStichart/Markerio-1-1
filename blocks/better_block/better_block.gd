class_name BetterBlock
extends StaticBody2D

@onready var state_chart := $StateChart
@onready var animation_player := $AnimationPlayer
@onready var coin_animation := $coin_animation
@onready var bounce_animation := $bounce_animation
@onready var sprite := $CollisionShape2D/Sprite2D

var coins: int = 1
var timer: float = 4

var item: String = ""

enum Appearance {brick, question, note}
enum Action {NOTHING, EXPLODE, PRODUCE_COIN, PRODUCE_ITEM, CHANGE_MUSIC}
var chosen_action := Action.NOTHING

var requested_item: String = ""


func set_appearance(appearance: Appearance):
	var animations_state := $StateChart/Root/Animations
	var brick := $StateChart/Root/Animations/brick
	var question := $StateChart/Root/Animations/question
	var note := $StateChart/Root/Animations/note
	match appearance:
		Appearance.brick:
			animations_state._initial_state = brick
		Appearance.question:
			animations_state._initial_state = question
		Appearance.brick:
			animations_state._initial_state = brick
		Appearance.note:
			animations_state._initial_state = note


func bounce():
	# TODO: play bounce sound
	state_chart.send_event("bounce")


func activate(powerup_wanted: String):
	requested_item = powerup_wanted
	if not animation_player.is_playing():
		state_chart.send_event("activate")


func _on_action_state_entered():
	bounce_animation.play("bounce")

	match chosen_action:
		Action.EXPLODE:
			explode()
		Action.PRODUCE_COIN:
			produce_coin()
		Action.PRODUCE_ITEM:
			produce_item()
		Action.CHANGE_MUSIC:
			change_music()
		_:
			state_chart.send_event("ready")

#region_start -- All the possible actions.
func explode():
	# TODO: play explode sound
	var explosion = $Explosion
	explosion.reparent(get_parent())
	explosion.emitting = true
	explosion.finished.connect(queue_free)
	queue_free()

func produce_coin():
	Sound.play_effect("coin_1")
	coin_animation.stop()
	coin_animation.play("emit_coin")
	coins -= 1
	state_chart.send_event("coins_pending")

func produce_item():
	var item_instance: Node2D
	if item == "Shroom":
		item_instance = InstanceManager.create(requested_item)
	else:
		item_instance = InstanceManager.create(item)
	add_sibling(item_instance)
	item_instance.global_position = global_position
	item_instance.process_mode = Node.PROCESS_MODE_DISABLED
	var t = get_tree().create_tween()
	t.tween_property(item_instance, "global_position", Vector2(global_position.x, global_position.y - Constants.BLOCK_SIZE), 1.0)
	t.tween_callback(func(): item_instance.process_mode = Node.PROCESS_MODE_INHERIT)
	state_chart.send_event("expired")

func change_music():
	Sound.cycle_music()
	state_chart.send_event("ready")
#region_end


func _on_on_bounce_taken():
	bounce_animation.play("bounce")


func _on_on_expired_taken():
	sprite.modulate = Color.DARK_GRAY


func _on_activated_state_physics_processing(delta):
	timer -= delta

	if timer <= 0 or coins <= 0:
		state_chart.send_event("expired")
