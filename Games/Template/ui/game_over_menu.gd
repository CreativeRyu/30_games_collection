extends MenuBase

signal restart_pressed
signal back_to_start_pressed

@onready var score_label = $CenterContainer/MarginContainer/Panel/VBoxContainer/Score_Label
@onready var highscore_label = $CenterContainer/MarginContainer/Panel/VBoxContainer/Highscore_Label

@export var animation_player: AnimationPlayer

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func show_menu(score: int, highscore: int, is_new: bool):
	score_label.text = "Score: %d" % score
	if is_new:
		highscore_label.text = "NEW Highscore: %d" % highscore
	else: 
		highscore_label.text = "Highscore: %d" % highscore
		
	var root = get_parent()
	if root:
		root.show()
		
	if animation_player.has_animation("game_over"):
		animation_player.play("game_over")
	await on_opened()

func _on_restart_button_pressed():
	emit_action(restart_pressed)

func _on_start_menu_button_pressed():
	emit_action(back_to_start_pressed)
