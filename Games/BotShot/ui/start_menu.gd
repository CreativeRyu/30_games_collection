extends MenuBase

signal start_game_pressed
signal back_to_main_menu_pressed
signal options_pressed

func _on_play_button_pressed():
	emit_action(start_game_pressed)

func _on_back_button_pressed() -> void:
	emit_action(back_to_main_menu_pressed)

func _on_options_button_pressed():
	emit_action(options_pressed)
