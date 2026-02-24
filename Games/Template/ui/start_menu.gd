extends Control

signal start_game_pressed
signal back_to_main_menu_pressed
signal pressed_action
signal options_pressed

@onready var play_button = $CenterContainer/MarginContainer/VBoxContainer/PlayButton

var is_button_locked = false

func on_opened():
	is_button_locked = false
	
	await get_tree().process_frame
	play_button.grab_focus()

func _emit_action(action: Signal):
	if is_button_locked:
		return
	is_button_locked = true
	action.emit()
	pressed_action.emit()

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and play_button.has_focus():
		_emit_action(start_game_pressed)

func _on_play_button_pressed():
	_emit_action(start_game_pressed)

func _on_back_button_pressed() -> void:
	_emit_action(back_to_main_menu_pressed)

func _on_options_button_pressed():
	_emit_action(options_pressed)
