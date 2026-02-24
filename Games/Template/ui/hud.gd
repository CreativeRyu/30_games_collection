extends Control

@onready var time_label = $Time_Label
@onready var score_label = $Score_Label

@export var score_prefix := ""
@export var time_prefix := ""

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
	if time_label:
		time_label.text = str(int(ceil(time_left)))

func _on_score_changed(score: int):
	if score_label:
		score_label.text = str(score)
