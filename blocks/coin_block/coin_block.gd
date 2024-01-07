class_name CoinBlock
extends Block

signal coin_block_expired

var timer = 1

func activate():
	activated = true
	produce_coin()



func _process(delta):
	if activated:
		timer -= delta
		if timer <= 0:
			coin_block_expired.emit(tile_pos)
			queue_free()
