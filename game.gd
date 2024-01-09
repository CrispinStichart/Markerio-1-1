class_name Game
extends Node2D


const BLOCK_SIZE: float = 512
const GRAVITY: float = BLOCK_SIZE*1.5
const MAX_FALL_SPEED: float = BLOCK_SIZE*15
const CAMERA_SCALE: float = .2

const level_scene := preload("res://level_1-1/level_1_1.tscn")

@onready var SCREEN_WIDTH = get_viewport().size.x / CAMERA_SCALE
@onready var UI: GameUI = $UILayer/UI
var level:Level = null

var lives:int = 5
var coins: int = 0
var score: int = 0


func _ready():
	reset_level()


func reset_level():
	if level:
		$GameLayer.remove_child(level)
		level.queue_free()




	level = level_scene.instantiate()
	$GameLayer.add_child(level)
	level.markerio.died.connect(markerio_death)

	level.flag.markerio_reached_flagpole.connect(func(): print("You did it!"))

	for block:Block in level.get_node("TileMap/blocks").get_children():
		if block is CoinBlock:
			block.coin_block_expired.connect(add_unbreakable_block)

	for enemy in level.get_node("enemies").get_children():
		enemy.process_mode = PROCESS_MODE_DISABLED


func _physics_process(_delta):
	if not level:
		return
	for enemy:Node2D in level.get_node("enemies").get_children():
		if abs(enemy.position.distance_to(level.markerio.position)) < SCREEN_WIDTH*2:
			enemy.process_mode = Node.PROCESS_MODE_INHERIT


func collect_coin():
	coins += 1
	score += 10
	if coins >= 100:
		coins -= 100
		lives += 1


func markerio_death():
	UI.show_death_screen(reset_level)



func add_unbreakable_block(pos: Vector2i):
	var tilemap: TileMap = level.get_node("TileMap")
	tilemap.set_cell(0, pos, 0, Vector2i(1, 0))
