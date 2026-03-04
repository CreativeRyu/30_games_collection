class_name InputHander
extends Node

signal pause_pressed
signal accept_pressed
signal cancel_pressed

static var using_mouse = true
var using_controller = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent):
	# Gerät erkennen
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		_set_mouse_mode(true)
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		_set_mouse_mode(false)

	if event.is_action_pressed("ui_pause"):
		pause_pressed.emit()

	if event.is_action_pressed("ui_accept"):
		accept_pressed.emit()

	if event.is_action_pressed("ui_cancel"):
		cancel_pressed.emit()

func _set_mouse_mode(is_mouse: bool):
	if is_mouse:
		if not using_mouse:
			using_mouse = true
			using_controller = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		if not using_controller:
			using_mouse = false
			using_controller = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# GamePads mit StickDrift dürfen nicht rein pfuschen		
func deadzone_check():
	var deadzone = 0.5
	var joystick_vector = Vector2(Input.get_joy_axis(0, 0), -Input.get_joy_axis(0,1)).length()
	return deadzone < joystick_vector
