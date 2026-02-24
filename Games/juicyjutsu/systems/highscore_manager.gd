extends Node

const SAVE_PATH = "user://juicyjutsu_highscore.cfg"
const SECTION = "scores"
const KEY = "highscore"

var highscore: int = 0

func _ready():
	load_highscore()

func load_highscore():
	var cfg = ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		highscore = cfg.get_value(SECTION, KEY, 0)
	else:
		highscore = 0

func save_highscore():
	var cfg = ConfigFile.new()
	cfg.set_value(SECTION, KEY, highscore)
	cfg.save(SAVE_PATH)

func get_highscore() -> int:
	return highscore

func try_set_highscore(score: int) -> bool:
	if score > highscore:
		highscore = score
		save_highscore()
		return true
	return false
