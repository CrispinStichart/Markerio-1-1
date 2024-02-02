class_name MetaGame
extends Node2D




@onready var state_chart = $StateChart
@onready var sub_viewport_container := $mask/SubViewportContainer
@onready var game := $mask/SubViewportContainer/SubViewport/Game
var normal_viewport_pos = Vector2(523, 234)
var secret_level_viewport_pos = Vector2(323, 91)

var music_tweener: Tween

func _ready():
	$MusicTitle.visible = false

	for child in $still_backgrounds.get_children():
		child.visible = false

	$still_backgrounds/beginning.visible = true
	sub_viewport_container.visible = false
	game.meta_game = self

	SignalBus.listen("music_changed", display_music_name)

func display_music_name(song_title: String):
	if music_tweener:
		music_tweener.kill()

	$MusicTitle.visible = true
	$MusicTitle.text = song_title
	$MusicTitle.modulate = Color.WHITE
	music_tweener = create_tween()
	music_tweener.tween_interval(1)
	music_tweener.tween_property($MusicTitle, "modulate", Color.TRANSPARENT, 1)
	music_tweener.tween_property($MusicTitle, "visible", false, 0)



func _on_intro_finished():
	state_chart.send_event("next")


func _on_placing_blank_whiteboard_finished():
	state_chart.send_event("next")



func _on_removing_instructions_finished():
	state_chart.send_event("next")


func swap_to_secret_level():
	state_chart.send_event("secret_level")


func swap_back_to_main_level():
	state_chart.send_event("normal_level")


func show_end_screen():
	state_chart.send_event("ending")



func _on_waiting_for_input_state_input(event):
	if event is InputEventKey and event.pressed:
		state_chart.send_event("next")



func _on_pregame_state_entered():
	$still_backgrounds/beginning.visible = true


func _on_pregame_state_exited():
	$still_backgrounds/beginning.visible = false


func _on_intro_video_state_entered():
	$videos/intro.play()


func _on_instructions_state_entered():
	$still_backgrounds/instructions.visible = true


func _on_instructions_state_exited():
	$still_backgrounds/instructions.visible = false


func _on_removing_instructions_state_entered():
	$videos/removing_instructions.play()


func _on_placing_whiteboard_state_entered():
	$videos/placing_blank_whiteboard.play()


func _on_removing_blank_whiteboard_finished():
	pass
	#state_chart.send_event("next")


func _on_playing_normal_level_state_entered():
	$still_backgrounds/blank_whiteboard.visible = true
	$AnimationPlayer.play("normal_level")
	sub_viewport_container.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	sub_viewport_container.visible = true


func _on_playing_secret_level_state_entered():
	sub_viewport_container.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	$videos/removing_blank_whiteboard.play()
	await $videos/removing_blank_whiteboard.finished
	$videos/placing_secret_level.play()
	$still_backgrounds/secret_level.visible = true
	$still_backgrounds/blank_whiteboard.visible = false
	await $videos/placing_secret_level.finished
	$AnimationPlayer.play("secret_level")
	sub_viewport_container.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	SignalBus.send_signal("secret_level_entered")


func _on_playing_secret_level_state_exited():
	sub_viewport_container.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	$videos/removing_secret_level.play()
	await $videos/removing_secret_level.finished
	$videos/placing_blank_whiteboard.play()
	$still_backgrounds/secret_level.visible = false
	$still_backgrounds/blank_whiteboard.visible = true
	await $videos/placing_blank_whiteboard.finished
	$AnimationPlayer.play("normal_level")
	sub_viewport_container.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	SignalBus.send_signal("secret_level_exited")
	SignalBus.send_signal("normal_level_entered")

# TODO: removing blank whiteboard will trigger "next" event due to signal on
# video player finished
func _on_placing_ending_state_entered():
	sub_viewport_container.visible = false
	sub_viewport_container.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	$videos/removing_blank_whiteboard.play()

	await $videos/removing_blank_whiteboard.finished
	$videos/placing_ending.play()
	$still_backgrounds/blank_whiteboard.visible = false
	$still_backgrounds/ending.visible = true
	await $videos/placing_ending.finished


func _on_removing_ending_state_entered():
	$still_backgrounds/ending.visible = false
	$videos/removing_ending.play()
	await $videos/removing_ending.finished
	state_chart.send_event("next")


#
#func _on_sub_viewport_container_visibility_changed():
	#if sub_viewport_container and sub_viewport_container.visible:
		#Sound.play_music("chill_music")
	#else:
		#Sound.pause_music()
