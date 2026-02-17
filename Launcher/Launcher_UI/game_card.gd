extends PanelContainer

@export var focus_scale : float = 1.04
@export var normal_scale : float = 1.0
@export var focus_border_color = Color.AQUAMARINE

@export var game_name: String
@export var game_number: String
@export var game_scene: PackedScene

@onready var number_label := $MarginContainer/VBoxContainer/Number_Label
@onready var title_label := $MarginContainer/VBoxContainer/Title_Label

var tween := create_tween()

var normal_style: StyleBoxFlat
var focus_style: StyleBoxFlat
var flash_style: StyleBoxFlat

signal start_game_requested(scene: PackedScene)

func _ready() -> void:
	number_label.text = game_number
	title_label.text = game_name
	
	tween = create_tween()
	tween.kill()
	
	_update_pivot()
	normal_style = get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	normal_style.set_border_width_all(3)
	normal_style.border_color = Color(1,1,1,0.06)
	
	focus_style = normal_style.duplicate()
	focus_style.border_color = focus_border_color
	
	flash_style = focus_style.duplicate()
	flash_style.border_color = Color("d5ffd4")
	
	# Initial Style setzen
	add_theme_stylebox_override("panel", normal_style)
	
	focus_entered.connect(_apply_focus)
	focus_exited.connect(_apply_unfocus)
	mouse_entered.connect(_on_mouse_entered)
	
	if has_focus():
		_apply_focus()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_update_pivot()

func _update_pivot():
	pivot_offset = (size * 0.5).round()

func _apply_focus():
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * focus_scale, 0.12)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	add_theme_stylebox_override("panel", focus_style)

func _apply_unfocus():
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * normal_scale, 0.12)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	add_theme_stylebox_override("panel", normal_style)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			grab_focus()
			_on_start_pressed()
			accept_event()
			return
			
	if event.is_action_pressed("ui_accept") and has_focus():
		_on_start_pressed()
		accept_event()
	
	
func _on_start_pressed() -> void:
	if not game_scene:
		push_warning("No game_scene set for GameCard: %s" % game_name)
		return
		
	_play_pressed_animation()
	
	await get_tree().create_timer(0.18).timeout
	
	start_game_requested.emit(game_scene)

func _on_mouse_entered():
	grab_focus()

func _play_pressed_animation() -> void:
	tween.kill()
	tween = create_tween()
	
	#  1️⃣ Border Flash AN
	tween.tween_callback(func():
		add_theme_stylebox_override("panel", flash_style)
	)

	# 2️⃣ Eindrücken
	tween.tween_property(self, "scale", Vector2.ONE * 0.96, 0.06)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	
	# 3️⃣ Zurückfedern (Punch)
	tween.tween_property(self, "scale", Vector2.ONE * focus_scale, 0.10)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	
	# 4️⃣ Border zurück zu Fokus
	tween.tween_callback(func():
		add_theme_stylebox_override("panel", focus_style)
	)
