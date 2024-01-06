class_name Game
extends Node2D


const BLOCK_SIZE: float = 512
const GRAVITY: float = BLOCK_SIZE*1.5
const CAMERA_SCALE: float = .2
var lives:int = 5
var coins: int = 0
var score: int = 0




func collect_coin():
	coins += 1
	score += 10
	if coins >= 100:
		coins -= 100
		lives += 1



