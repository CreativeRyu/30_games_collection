extends TextureButton

@export var hover_scale: float = 1.03
@export var pressed_scale: float = 0.98
@onready var focus_frame = $FocusFrame

var base_scale := Vector2.ONE
var is_pressing = false
var tween : Tween

func _ready():
	await get_tree().process_frame
	base_scale = scale
	
	pivot_offset = size / 2

	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)

	button_down.connect(_on_down)
	button_up.connect(_on_up)

	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)

# HOVER
func _on_hover():
	if is_pressed():
		return
	_scale_to(hover_scale)

func _on_unhover():
	if is_pressed():
		return

	if not has_focus():
		_scale_to(1.0)

# PRESS
func _on_down():
	is_pressing = true
	focus_frame.visible = false
	_scale_to(pressed_scale)

func _on_up():
	is_pressing = false
	focus_frame.visible = true
	await get_tree().process_frame
	if is_hovered() or has_focus():
		_scale_to(hover_scale)
	else:
		_scale_to(1.0)

# FOCUS (Controller)
func _on_focus_entered():
	focus_frame.visible = true
	if is_pressed():
		return
	_scale_to(hover_scale)

func _on_focus_exited():
	focus_frame.visible = false
	if is_pressed():
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
