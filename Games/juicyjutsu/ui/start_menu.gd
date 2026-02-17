extends Control

signal start_game_pressed
signal back_to_main_menu_pressed
signal pressed_action

@onready var play_button = $CenterContainer/MarginContainer/VBoxContainer/PlayButton

func on_opened():
	await get_tree().process_frame
	play_button.grab_focus()

func _emit_action(action: Signal):
	action.emit()
	pressed_action.emit()

func _on_play_button_pressed():
	_emit_action(start_game_pressed)

func _on_back_button_pressed() -> void:
	_emit_action(back_to_main_menu_pressed)
