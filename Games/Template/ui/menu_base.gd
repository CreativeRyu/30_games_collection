class_name MenuBase
extends Control

signal pressed_action

@export var default_focus_path : NodePath

var is_button_locked := false

func _enter_tree():
	add_to_group("menus")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func on_opened():
	is_button_locked = false
	await get_tree().process_frame

	if not default_focus_path.is_empty():
		var node = get_node_or_null(default_focus_path)

		if node and node.has_method("grab_focus"):
			node.grab_focus()
		else:
			_focus_first_button()

func _focus_first_button():
	var buttons = find_children("*", "BaseButton")
	if buttons.size() > 0:
		buttons[0].grab_focus()

func _unhandled_input(event):
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("ui_accept", true):
		_on_accept_pressed()
	if event.is_action_pressed("ui_cancel", true):
		_on_cancel_pressed()

func _on_accept_pressed():
	var focus = get_viewport().gui_get_focus_owner()
	if focus and focus is BaseButton and is_ancestor_of(focus):
		focus.pressed.emit()

func _on_cancel_pressed():
	pass

func emit_action(signal_to_emit : Signal):
	if is_button_locked:
		return
	is_button_locked = true
	signal_to_emit.emit()
	pressed_action.emit()
