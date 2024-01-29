class_name GameUI
extends CanvasGroup

var t: Tween

func _ready():
	$Control/Wasted.visible = false
	SignalBus.listen("update_coins", update_coins)
	SignalBus.listen("update_score", update_score)
	SignalBus.listen("normal_level_entered", func(): $AnimationPlayer.play("normal_level"))
	SignalBus.listen("secret_level_entered", func(): $AnimationPlayer.play("secret_level"))

func show_death_screen(callback: Callable):
	$Control/Wasted.visible = true
	t = create_tween()
	t.tween_property($Control/Wasted, "visible", false, 2)
	t.tween_callback(callback)


func update_score(score: int):
	$Control/score.text = str(score).lpad(6, "0")

func update_coins(coins: int):
	$Control/coins.text = str(coins).lpad(3, "0")
