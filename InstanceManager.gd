class_name InstanceManager
extends Node

static var instances := {
	Shroom: preload("res://collectible/shroom/shroom.tscn"),
	FireFlower: preload("res://collectible/fire_flower/fire_flower.tscn"),
	Star: preload("res://collectible/star/star.tscn"),
	Coin: preload("res://collectible/coin/coin.tscn"),
	BreakableBrick: preload("res://blocks/breakable/brick.tscn"),
	QuestionBlock: preload("res://blocks/question/question_block.tscn"),
	Fireball: preload("res://markerio/fireball/fireball.tscn")
}

static func create(clazz) -> Node2D:
	return instances[clazz].instantiate()
