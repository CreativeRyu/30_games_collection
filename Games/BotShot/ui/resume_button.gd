extends Button

@export var hover_scale: float = 1.02
@export var pressed_scale: float = 0.99

@onready var focus_frame = $FocusFrame

var base_scale := Vector2.ONE
var is_pressing = false
var tween : Tween

var normal_style: StyleBox
var hover_style: StyleBox
var pressed_style: StyleBox

func _ready():
	await get_tree().process_frame
	base_scale = scale
	
	pivot_offset = size / 2
	
	# Styles aus Theme holen
	normal_style = get_theme_stylebox("normal")
	hover_style = get_theme_stylebox("hover")
	pressed_style = get_theme_stylebox("pressed")

	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)

	button_down.connect(_on_down)
	button_up.connect(_on_up)

	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)

func _update_highlight():
	if is_pressed():
		return
	var focus_owner = get_viewport().gui_get_focus_owner()
	
	if focus_owner and focus_owner != self:
		if has_focus():
			_scale_to(hover_scale)
		else:
			_scale_to(1.0)
		return

	# Normalfall
	if is_hovered() or has_focus():
		_scale_to(hover_scale)
	else:
		_scale_to(1.0)

# HOVER
func _on_hover():
	if is_pressing:
		return
	grab_focus()
	_update_highlight()

func _on_unhover():
	if is_pressing:
		return
	_update_highlight()
	
# PRESS
func _on_down():
	is_pressing = true
	remove_theme_stylebox_override("hover")
	remove_theme_stylebox_override("focus")
	add_theme_stylebox_override("focus", pressed_style)
	#focus_frame.visible = false
	_scale_to(pressed_scale)

func _on_up():
	is_pressing = false
	remove_theme_stylebox_override("focus")
	add_theme_stylebox_override("focus", hover_style)
	#focus_frame.visible = true
	await get_tree().process_frame
	_update_highlight()

# FOCUS (Controller)
func _on_focus_entered():
	_apply_focus_style()
	if is_pressed() or is_pressing:
		return
	_scale_to(hover_scale)

func _on_focus_exited():
	_remove_focus_style()
	if is_pressed() or is_pressing:
		return
	if not is_hovered():
		_scale_to(1.0)

# SCALE FUNCTION
func _scale_to(multiplier: float):
	if tween:
		tween.kill()

	tween = create_tween()

	tween.tween_property(self, "scale", Vector2(multiplier, multiplier), 0.12).set_trans(Tween.TRANS_BACK)\
	 .set_ease(Tween.EASE_OUT)

func _apply_focus_style():
	add_theme_stylebox_override("focus", hover_style)

func _remove_focus_style():
	remove_theme_stylebox_override("focus")
