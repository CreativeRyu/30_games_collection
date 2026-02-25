extends Node2D

enum GameState {START, PLAYING, PAUSED, GAME_OVER}
var current_state: GameState = -1

@onready var gameplay = $GamePlay
@onready var start_menu = $UI/StartMenu
@onready var pause_menu = $UI/PauseMenu
@onready var hud = $UI/Hud
@onready var audio_manager = $AudioManager
@onready var game_over_menu = $UI/GameOverMenu
@onready var highscore_manager = $HighscoreManager
@onready var fruit_spawner = $GamePlay/FruitSpawner
@onready var score_system: ScoreSystem = $GamePlay/ScoreSystem
@onready var camera_shake = $CameraShake
@export var start_menu_BGM: AudioStream
@export var gameplay_BGM: AudioStream

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_connect_ui()
	set_state(GameState.START)
	
func _connect_ui():
	# Start Menu Connects
	start_menu.start_game_pressed.connect(start_game)
	start_menu.back_to_main_menu_pressed.connect(back_to_main_menu)
	start_menu.pressed_action.connect(_on_ui_pressed)
	
	# Pause Menu Connects
	pause_menu.resume_pressed.connect(resume_game)
	pause_menu.pressed_action.connect(_on_ui_pressed)
	pause_menu.exit_to_menu_pressed.connect(back_to_start_menu)

	hud.bind_score_system(score_system)
	fruit_spawner.fruit_spawned.connect(_on_fruit_spawned)
	fruit_spawner.burst_spawned.connect(_on_burst_spawned)
	score_system.time_over.connect(trigger_game_over)
	
	# GameOver Menu Connects
	game_over_menu.restart_pressed.connect(restart_game)
	game_over_menu.exit_to_menu_pressed.connect(back_to_start_menu)
	game_over_menu.pressed_action.connect(_on_ui_pressed)
	
func set_state(state: GameState):
	if current_state == state:
		return
	current_state = state
	start_menu.visible = state == GameState.START
	gameplay.visible  = state != GameState.START
	hud.visible = state == GameState.PLAYING
	pause_menu.visible = state == GameState.PAUSED
	game_over_menu.visible = state == GameState.GAME_OVER
	
	match state:
		GameState.START:
			audio_manager.play_music(start_menu_BGM)
			start_menu.on_opened()
		
		GameState.PLAYING:
			audio_manager.play_music(gameplay_BGM)
		
		GameState.PAUSED:
			audio_manager.pause_music()
			
		GameState.GAME_OVER:
			audio_manager.stop_music()
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if current_state != GameState.PLAYING and not get_tree().paused:
			return
		if get_tree().paused:
			resume_game()
		elif gameplay.visible:
			pause_game()

func start_game():
	set_state(GameState.PLAYING)
	score_system.start_round()
	fruit_spawner.start()

func pause_game():
	score_system.pause_round()
	fruit_spawner.stop()
	set_state(GameState.PAUSED)
	get_tree().paused = true
	pause_menu.on_opened()
	
func resume_game():
	get_tree().paused = false
	set_state(GameState.PLAYING)
	score_system.resume_round()
	audio_manager.resume_music()
	fruit_spawner.start()
	
func back_to_main_menu():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Launcher/Main_Menu/main_menu.tscn")

func _on_fruit_spawned(fruit):
	if fruit.has_signal("exploded"):
		fruit.exploded.connect(_on_bomb_exploded)
	
	if fruit.has_signal("smashed"):
		fruit.smashed.connect(_on_fruit_smashed)

func _on_bomb_exploded():
	camera_shake.shake(15.0)
	trigger_game_over()

func trigger_game_over():
	set_state(GameState.GAME_OVER)
	fruit_spawner.stop()
	score_system.stop_round()
	get_tree().paused = true
	var score = score_system.get_score()
	var is_new_highscore = highscore_manager.try_set_highscore(score)
	var highscore = highscore_manager.get_highscore()

	# GameOver UI
	game_over_menu.show_menu(score, highscore, is_new_highscore)

func _on_ui_pressed():
	audio_manager.play_button_pressed()
	
func back_to_start_menu():
	get_tree().paused = false
	fruit_spawner.stop()
	score_system.start_round()
	audio_manager.play_music(start_menu_BGM)
	
	set_state(GameState.START)

func restart_game():
	get_tree().paused = false
	score_system.start_round()
	fruit_spawner.start()
	audio_manager.play_music(gameplay_BGM)
	set_state(GameState.PLAYING)

func _on_burst_spawned(intensity: float):
	camera_shake.shake(intensity)

func _on_fruit_smashed(speed: float):
	var intensity = clamp(speed / 200.0, 0.6, 2.0)
	camera_shake.shake(intensity)
