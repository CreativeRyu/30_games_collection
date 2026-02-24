extends Control

signal resume_pressed
signal restart_pressed
signal back_to_start_pressed
signal pressed_action

@onready var resume_button = $VBoxContainer/ResumeButton

var is_button_locked: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func on_opened():
	is_button_locked = false
	
	await get_tree().process_frame
	resume_button.grab_focus()

func _emit_action(action: Signal):
	if is_button_locked:
		return
	is_button_locked = true
		
	action.emit()
	pressed_action.emit()

func _unhandled_input(event):
	if not visible:
		return
	if event.is_action_pressed("ui_accept", true) and resume_button.has_focus():
		_emit_action(resume_pressed)

func _on_resume_button_pressed():
	_emit_action(resume_pressed)

func _on_back_button_pressed():
	_emit_action(back_to_start_pressed)

func _on_restart_button_pressed() -> void:
	_emit_action(restart_pressed)
