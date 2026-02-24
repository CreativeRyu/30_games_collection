extends Control

signal resume_pressed
signal exit_to_menu_pressed
signal pressed_action

@onready var resume_button = $VBoxContainer/ResumeButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func on_opened():
	await get_tree().process_frame
	resume_button.grab_focus()

func _emit_action(action: Signal):
	action.emit()
	pressed_action.emit()

func _on_resume_button_pressed():
	_emit_action(resume_pressed)

func _on_back_button_pressed():
	_emit_action(exit_to_menu_pressed)
