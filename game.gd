class_name Game
extends Node2D



const level_scene := preload("res://level_1-1/level_1_1.tscn")
const secret_level_scene := preload("res://secret_level/secret_level.tscn")

@onready var SCREEN_WIDTH = get_viewport().size.x / Constants.CAMERA_SCALE
@onready var UI: GameUI = $UILayer/UI

var level:Level = null
var secret_level:SecretLevel = null

var lives: int = 5
var coins: int = 0
var score: int = 0

var meta_game: MetaGame


func _ready():
	Sound.play_music("chill_music")
	reset_level()
	level.secret_area_entered.connect(secret_area_entered)

	SignalBus.listen("coin_collected", collect_coin)
	SignalBus.listen("coin_block_expired", add_unbreakable_block)


func reset_level(warp_pipe := false):
	print("resetting level...")
	if level:
		$GameLayer.remove_child(level)
		level.queue_free()

	level = level_scene.instantiate()
	print("adding level")
	$GameLayer.add_child(level)
	level.markerio.died.connect(markerio_death)

	level.flag.markerio_reached_flagpole.connect(
			func():
				if meta_game:
					meta_game.show_end_screen()
				call_deferred("reset_level")
	)

	for block:Block in level.get_node("TileMap/blocks").get_children():

		if block is BreakableBrick:
			block.expired.connect(add_unbreakable_block)

	for enemy in level.get_node("enemies").get_children():
		enemy.process_mode = PROCESS_MODE_DISABLED

	if warp_pipe:
		print("calling exit warp pipe")
		level.exit_warp_pipe()

func _physics_process(_delta):
	if not level:
		return
	for enemy:Node2D in level.get_node("enemies").get_children():
		if abs(enemy.position.distance_to(level.markerio.position)) < SCREEN_WIDTH:
			enemy.process_mode = Node.PROCESS_MODE_INHERIT


func collect_coin():
	coins += 1
	SignalBus.send_signal("update_coins", [coins])
	Sound.play_effect("coin_1")


func add_to_score(score_to_add: int):
	score += score_to_add
	SignalBus.send_signal("update_score", [score])


func markerio_death():
	UI.show_death_screen(reset_level)


func add_unbreakable_block(pos: Vector2i):
	var tilemap: TileMap = level.get_node("TileMap")
	tilemap.set_cell(0, pos, 0, Vector2i(1, 0))

func secret_area_entered():
	print("Secret area entered")
	if meta_game:
		meta_game.swap_to_secret_level()
		await meta_game.secret_level_entered



	secret_level = secret_level_scene.instantiate()
	print("Setting secret level to: ", secret_level)
	$GameLayer.add_child(secret_level)
	var markerio = secret_level.get_node("Markerio")
	var secret_level_position = markerio.global_position
	secret_level.remove_child(markerio)
	markerio = level.get_node("Markerio")
	markerio.reparent(secret_level)
	markerio.global_position = secret_level_position
	markerio.set_collision(true)
	markerio.enable_input()
	secret_level.secret_area_exited.connect(secret_area_left)
	level.process_mode = Node.PROCESS_MODE_DISABLED
	level.visible = false


func secret_area_left():
	print("Secret area left!")
	if meta_game:
		meta_game.swap_back_to_main_level()
		await meta_game.secret_level_exited

	secret_level.get_node("Markerio").reparent(level)
	$GameLayer.call_deferred("remove_child", secret_level)
	secret_level.queue_free()
	secret_level = null
	level.process_mode = Node.PROCESS_MODE_ALWAYS
	level.visible = true
	level.exit_warp_pipe()

