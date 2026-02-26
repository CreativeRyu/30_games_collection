extends Node

signal pause_pressed
signal accept_pressed
signal cancel_pressed

var using_controller := false

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		using_controller = true

	if event is InputEventScreenTouch:
		using_controller = false

	if event.is_action_pressed("ui_pause"):
		pause_pressed.emit()

	if event.is_action_pressed("ui_accept"):
		accept_pressed.emit()

	if event.is_action_pressed("ui_cancel"):
		cancel_pressed.emit()
