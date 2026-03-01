extends Node

signal time_changed(time_left: float)
signal score_changed(score: int)
signal time_over

@export var round_time: float = 60.0

var time_left : float
var score: int = 0
var is_round_running = false
var last_emitted_time := -1

func start_round():
	time_left = round_time
	score = 0
	is_round_running = true
	time_changed.emit(time_left)
	score_changed.emit(score)

func pause_round():
	is_round_running = false

func resume_round():
	is_round_running = true

func stop_round():
	is_round_running = false

func _process(delta: float) -> void:
	if not is_round_running:
		return
	
	time_left -= delta
	time_left = max(time_left, 0.0)
	
	var display_time = int(ceil(time_left))
	if display_time != last_emitted_time:
		last_emitted_time = display_time
		time_changed.emit(time_left)
	
	if time_left <= 0.0:
		is_round_running = false
		time_over.emit()

func add_score(amount: int):
	if not is_round_running:
		return
	
	score += amount
	score_changed.emit(score)

func get_score() -> int:
	return score
