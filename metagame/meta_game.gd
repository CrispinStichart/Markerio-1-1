class_name MetaGame
extends Node2D


signal secret_level_entered
signal secret_level_exited



enum State {TRANSITIONING, WAITING_FOR_START_INPUT, WAITING_FOR_INSTRUCTION_INPUT, WAITING_FOR_ENDING_INPUT, PLAYING_MAIN_GAME, PLAYING_SCRET_LEVEL}
var state := State.WAITING_FOR_START_INPUT

var normal_viewport_pos = Vector2(523, 234)
var secret_level_viewport_pos = Vector2(323, 91)

func _ready():
	$still_backgrounds/beginning.visible = true
	$SubViewportContainer.visible = false
	$SubViewportContainer/SubViewport/Game.meta_game = self

	
func _input(event: InputEvent):
	if event is InputEventKey:
		if state == State.WAITING_FOR_START_INPUT:
			state = State.TRANSITIONING
			$still_backgrounds/beginning.visible = false
			$still_backgrounds/instructions.visible = true
			$videos/intro.play()
		elif state == State.WAITING_FOR_INSTRUCTION_INPUT:
				state = State.TRANSITIONING
				$videos/removing_instructions.play()
		elif state == State.WAITING_FOR_ENDING_INPUT:
				print("test")
				state = State.TRANSITIONING
				$still_backgrounds/ending.visible = false
				$videos/removing_ending.play()
				await $videos/removing_ending.finished
				$videos/placing_blank_whiteboard.play()
				await $videos/placing_blank_whiteboard.finished

				$SubViewportContainer/SubViewport/Game.call_deferred("reset_level")
				

		
func _on_intro_finished():
	state = State.WAITING_FOR_INSTRUCTION_INPUT


func _on_placing_blank_whiteboard_finished():
	$still_backgrounds/instructions.visible = false
	$still_backgrounds/blank_whiteboard.visible = true
	state = State.PLAYING_MAIN_GAME
	$AnimationPlayer.play("normal_level")
	$SubViewportContainer.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	$SubViewportContainer.visible = true


func _on_removing_instructions_finished():
	$videos/placing_blank_whiteboard.play()

func _on_removing_blank_whiteboard_finished():
	pass # Replace with function body.

func swap_to_secret_level():
	$SubViewportContainer.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	$videos/removing_blank_whiteboard.play()
	await $videos/removing_blank_whiteboard.finished
	$videos/placing_secret_level.play()
	$still_backgrounds/secret_area.visible = true
	$still_backgrounds/blank_whiteboard.visible = false
	await $videos/placing_secret_level.finished
	$AnimationPlayer.play("secret_level")
	$SubViewportContainer.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	secret_level_entered.emit()
	
func swap_back_to_main_level():
	$SubViewportContainer.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	$videos/removing_secret_level.play()
	await $videos/removing_secret_level.finished
	$videos/placing_blank_whiteboard.play()
	$still_backgrounds/secret_area.visible = false
	$still_backgrounds/blank_whiteboard.visible = true
	await $videos/placing_blank_whiteboard.finished
	$AnimationPlayer.play("normal_level")
	$SubViewportContainer.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	secret_level_exited.emit()


func show_end_screen():
	$SubViewportContainer.visible = false
	$SubViewportContainer.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	$videos/removing_blank_whiteboard.play()
	state = State.TRANSITIONING
	await $videos/removing_blank_whiteboard.finished
	$videos/placing_ending.play()
	$still_backgrounds/blank_whiteboard.visible = false
	$still_backgrounds/ending.visible = true
	await $videos/placing_ending.finished
	state = State.WAITING_FOR_ENDING_INPUT
