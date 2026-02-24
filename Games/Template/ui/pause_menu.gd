extends MenuBase

signal resume_pressed
signal restart_pressed
signal back_to_start_pressed

func _on_resume_button_pressed():
	emit_action(resume_pressed)

func _on_back_button_pressed():
	emit_action(back_to_start_pressed)

func _on_restart_button_pressed() -> void:
	emit_action(restart_pressed)

func _on_cancel_pressed():
	emit_action(resume_pressed)
