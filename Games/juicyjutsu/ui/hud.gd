extends Control

@onready var time_label = $Time_Label
@onready var score_label = $Score_Label
@onready var score_animation_player = $ScoreAnimationPlayer
@onready var timer_animation_player = $TimerAnimationPlayer

@export var score_prefix := ""
@export var time_prefix := ""
@export var warning_time = 10

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func bind_score_system(score_system):	
	if score_system.has_signal("time_changed"):
		if score_system.time_changed.is_connected(_on_time_changed):
			score_system.time_changed.disconnect(_on_time_changed)
		score_system.time_changed.connect(_on_time_changed)

	if score_system.has_signal("score_changed"):
		if score_system.score_changed.is_connected(_on_score_changed):
			score_system.score_changed.disconnect(_on_score_changed)
		score_system.score_changed.connect(_on_score_changed)

func _on_time_changed(time_left: float):
	time_label.text = str(int(ceil(time_left)))

	if time_left <= warning_time:
		if timer_animation_player.has_animation("time_warning"):
			if timer_animation_player.current_animation != "time_warning":
				timer_animation_player.play("time_warning")
	else:
		timer_animation_player.stop()

func _on_score_changed(score: int):
	score_label.text = str(score)
	if score > 0:
		if score_animation_player.current_animation != "score_pulse" and score_animation_player.has_animation("score_pulse"):
			score_animation_player.play("score_pulse")
