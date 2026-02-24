extends CanvasLayer

signal restart_pressed
signal exit_to_menu_pressed
signal pressed_action

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score_label = $CenterContainer/MarginContainer/Panel/VBoxContainer/Score_Label
@onready var highscore_label = $CenterContainer/MarginContainer/Panel/VBoxContainer/Highscore_Label
@onready var restart_button = $CenterContainer/MarginContainer/Panel/VBoxContainer/Restart_Button

var is_button_locked: bool = false

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func on_opened():
	is_button_locked = false
	await get_tree().process_frame
	restart_button.grab_focus()

func show_menu(score: int, highscore: int, is_new: bool):
	score_label.text = "Score: %d" % score
	if is_new:
		highscore_label.text = "NEW Highscore: %d" % highscore
	else: 
		highscore_label.text = "Highscore: %d" % highscore
	show()
	animation_player.play("game_over")
	await on_opened()

func _unhandled_input(event):
	if not visible:
		return

	if event.is_action_pressed("ui_accept") and restart_button.has_focus():
		_emit_action(restart_pressed)

func _emit_action(action: Signal):
	if is_button_locked:
		return
	is_button_locked = true
		
	action.emit()
	pressed_action.emit()

func _on_restart_button_pressed():
	_emit_action(restart_pressed)

func _on_start_menu_button_pressed():
	_emit_action(exit_to_menu_pressed)
