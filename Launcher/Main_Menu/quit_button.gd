extends Button

@onready var icon_texture: TextureRect = $TextureRect

var base_scale = Vector2.ONE
var pressed_scale = Vector2(0.9, 0.9)

func _ready() -> void:
	await get_tree().process_frame
	
	icon_texture.pivot_offset = icon_texture.size * 0.5
	base_scale = icon_texture.scale
	
	# Focus (GamePad | Keyboard)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	
	# Mouse Over
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# Button Press
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_focus_entered():
	_set_highlight(true)

func _on_focus_exited():
	_set_highlight(false)

func _on_button_down():
	icon_texture.scale = pressed_scale
	icon_texture.modulate = Color(0.85, 0.85, 0.85)

func _on_button_up():
	_animate_back()

func _on_mouse_entered():
	grab_focus()
	icon_texture.modulate = Color(1.1, 1.1, 1.1)

func _on_mouse_exited():
	if has_focus():
		return
	icon_texture.modulate = Color(0.9, 0.9, 0.9)

func _animate_back():
	var tween := create_tween()
	tween.tween_property(icon_texture, "scale", base_scale, 0.12)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(icon_texture, "position:y", 0.0, 0.08)
	tween.tween_property(icon_texture, "modulate", Color(1,1,1), 0.08)

func _set_highlight(active: bool):
	if active:
		icon_texture.modulate = Color(1, 1, 1)
	else:
		icon_texture.modulate = Color(0.9, 0.9, 0.9)
