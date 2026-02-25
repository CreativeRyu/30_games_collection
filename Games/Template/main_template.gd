extends GameRootBase

@onready var audio_manager = $AudioManager
@onready var highscore_manager = $HighscoreManager
@onready var score_system = $GamePlay/ScoreSystem
@onready var camera_shake = $CameraShake

@export var start_menu_BGM: AudioStream
@export var gameplay_BGM: AudioStream

func _connect_ui():
	var menus = get_tree().get_nodes_in_group("menus")
	for menu in menus:
		# ---------- GLOBAL BUTTON SOUND ----------
		if menu.has_signal("pressed_action"):
			menu.pressed_action.connect(_on_ui_pressed)
		# ---------- START GAME ----------
		if menu.has_signal("start_game_pressed"):
			menu.start_game_pressed.connect(start_game)
		# ---------- RESUME ----------
		if menu.has_signal("resume_pressed"):
			menu.resume_pressed.connect(resume_game)
		# ---------- RESTART ----------
		if menu.has_signal("restart_pressed"):
			menu.restart_pressed.connect(restart_game)
		# ---------- BACK TO START ----------
		if menu.has_signal("back_to_start_pressed"):
			menu.back_to_start_pressed.connect(back_to_start_menu)
		# ---------- EXIT TO LAUNCHER ----------
		if menu.has_signal("back_to_main_menu_pressed"):
			menu.back_to_main_menu_pressed.connect(back_to_launcher)
		
		# Debug Check ob Menüs alle conncected sind
		#print("Connected Menu:", menu.name)

	# ---------- HUD ----------
	if hud and score_system:
		hud.bind_score_system(score_system)

	# ---------- GAMEPLAY ----------
	if score_system:
		score_system.time_over.connect(trigger_game_over)

func _on_state_changed(state):
	match state:
		GameState.START:
			audio_manager.play_music(start_menu_BGM)
		GameState.PLAYING:
			audio_manager.play_music(gameplay_BGM)
		GameState.PAUSED:
			audio_manager.pause_music()
		GameState.GAME_OVER:
			audio_manager.stop_music()
	
func start_game():
	if score_system:
		score_system.start_round()
	set_state(GameState.PLAYING)

func pause_game():
	if score_system:
		score_system.pause_round()
	set_state(GameState.PAUSED)
	get_tree().paused = true
	
func resume_game():
	get_tree().paused = false
	if score_system:
		score_system.resume_round()

	if audio_manager:
		audio_manager.resume_music()
		
	set_state(GameState.PLAYING)

func trigger_game_over():
	get_tree().paused = true
	if score_system:
		score_system.stop_round()
	var score = score_system.get_score()
	var is_new_highscore = highscore_manager.try_set_highscore(score)
	var highscore = highscore_manager.get_highscore()

	# GameOver UI
	game_over_menu.show_menu(score, highscore, is_new_highscore)
	set_state(GameState.GAME_OVER)


func back_to_start_menu():
	get_tree().paused = false
	if score_system:
		score_system.stop_round()
	set_state(GameState.START)

func restart_game():
	get_tree().paused = false
	if score_system:
		score_system.start_round()
	set_state(GameState.PLAYING)

func _on_ui_pressed():
	if audio_manager:
		audio_manager.play_sound("button")

func back_to_launcher():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Launcher/Main_Menu/main_menu.tscn")
