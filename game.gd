class_name Game
extends Node2D


const BLOCK_SIZE: float = 512
const GRAVITY: float = BLOCK_SIZE*1.5
const MAX_FALL_SPEED: float = BLOCK_SIZE*15
const CAMERA_SCALE: float = .2


var lives:int = 5
var coins: int = 0
var score: int = 0

var markerio: Markerio

func _ready():
	markerio = $"GameLayer/level_1-1/Markerio"
	markerio.died.connect(markerio_death)

	for block:Block in $"GameLayer/level_1-1/TileMap/blocks".get_children():
		if block is CoinBlock:
			block.coin_block_expired.connect(add_unbreakable_block)

func collect_coin():
	coins += 1
	score += 10
	if coins >= 100:
		coins -= 100
		lives += 1


func markerio_death():
	markerio.position = $"GameLayer/level_1-1/markerio_spawn_point".position


func add_unbreakable_block(pos: Vector2i):
	var tilemap: TileMap = $"GameLayer/level_1-1/TileMap"
	tilemap.set_cell(0, pos, 0, Vector2i(1, 0))
