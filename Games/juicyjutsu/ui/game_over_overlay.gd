extends CanvasLayer

signal restart_pressed
signal exit_to_menu_pressed

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score_label = $CenterContainer/MarginContainer/Panel/VBoxContainer/Score_Label
@onready var highscore_label = $CenterContainer/MarginContainer/Panel/VBoxContainer/Highscore_Label
@onready var restart_button = $CenterContainer/MarginContainer/Panel/VBoxContainer/Restart_Button


func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func on_opened():
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
	on_opened()

func _on_restart_button_pressed():
	restart_pressed.emit()

func _on_start_menu_button_pressed():
	exit_to_menu_pressed.emit()
