class_name HighscoreManager
extends Node

signal highscore_changed(new_highscore)

@export_file("*.cfg")
var save_file_name := "default_highscore.cfg"

const SECTION = "scores"
const KEY = "highscore"

var highscore: int = 0
var is_loaded = false

func _ready():
	load_highscore()

func _get_save_path() -> String:
	if save_file_name.is_empty():
		push_warning("HighscoreManager: No save file defined.")
		return ""
	return "user://" + save_file_name

func load_highscore():
	var path = _get_save_path()
	if path.is_empty():
		return
	var cfg = ConfigFile.new()
	var load_status = cfg.load(path)
	
	if load_status == OK:
		highscore = cfg.get_value(SECTION, KEY, 0)
	else:
		highscore = 0
		
	is_loaded = true
	highscore_changed.emit(highscore)

func save_highscore():
	var path = _get_save_path()
	if path.is_empty():
		return
	var cfg = ConfigFile.new()
	cfg.set_value(SECTION, KEY, highscore)
	var save_status = cfg.save(path)
	
	if save_status != OK:
		push_warning("Highscore save failed")


func get_highscore() -> int:
	return highscore

func try_set_highscore(score: int) -> bool:
	if not is_loaded:
		load_highscore()
	if score > highscore:
		highscore = score
		save_highscore()
		highscore_changed.emit(highscore)
		return true
	return false

func reset_highscore():
	if not is_loaded:
		load_highscore()
	highscore = 0
	save_highscore()
	highscore_changed.emit(highscore)
