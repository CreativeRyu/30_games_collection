class_name ScoreSystem
extends Node

signal score_changed(score: int)
signal time_changed(time_left: float)
signal round_started
signal round_ended
signal time_over

@export var round_time: float = 60.0
@export var use_timer: bool = true

var time_left: float = 0.0
var score: int = 0
var is_round_running = false
var last_emitted_time := -1

func _ready():
	set_process(false)

func start_round():
	score = 0
	score_changed.emit(score)
	if use_timer:
		time_left = round_time
		last_emitted_time = -1
		time_changed.emit(time_left)
	is_round_running = true
	round_started.emit()
	set_process(true)
	

func pause_round():
	is_round_running = false

func resume_round():
	is_round_running = true

func stop_round():
	is_round_running = false
	round_ended.emit()
	set_process(false)

func _process(delta: float) -> void:
	if not is_round_running:
		return
	
	if use_timer:
		time_left -= delta
		time_left = max(time_left, 0.0)
	
		var display_time = int(ceil(time_left))
		if display_time != last_emitted_time:
			last_emitted_time = display_time
			time_changed.emit(time_left)
	
		if time_left <= 0:
			is_round_running = false
			time_over.emit()
			round_ended.emit()

func add_score(amount: int):
	if not is_round_running or amount <= 0:
		return
	
	score += amount
	score_changed.emit(score)

func get_score() -> int:
	return score

func get_time_left() -> float:
	return time_left
