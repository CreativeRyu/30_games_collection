extends Control

@onready var time_label = $Time_Label
@onready var score_label = $Score_Label

func bind_score_system(score_system):
	score_system.time_changed.connect(_on_time_changed)
	score_system.score_changed.connect(_on_score_changed)

func _on_time_changed(time_left: float):
	time_label.text = str(int(ceil(time_left)))

func _on_score_changed(score: int):
	score_label.text = str(score)
