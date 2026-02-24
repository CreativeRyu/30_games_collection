class_name GameRootBase
extends Node2D

signal state_changed(new_state)
signal request_exit_to_launcher

enum GameState {START, PLAYING, PAUSED, GAME_OVER}
var current_state : GameState = GameState.START

@onready var gameplay = get_node_or_null("GamePlay")
@onready var ui = get_node_or_null("UI")
@onready var start_menu = get_node_or_null("UI/StartMenu")
@onready var pause_menu = get_node_or_null("UI/PauseMenu")
@onready var hud = get_node_or_null("UI/HUD")
@onready var game_over_menu = get_node_or_null("UI/GameOverMenu")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_connect_ui()
	set_state(GameState.START)
	
func _connect_ui():
	# Start Menu Connects
	
	# Pause Menu Connects
	
	# GameOver Menu Connects
	
	# GamePlay Connects
	if get_script() == GameRootBase:
		push_warning("GameRootBase _connect_ui not implemented.")

func set_state(new_state : GameState):
	if current_state == new_state:
		return
	current_state = new_state
	
	if start_menu:
		start_menu.visible = new_state == GameState.START
	if gameplay:
		gameplay.visible = new_state != GameState.START
	if hud:
		hud.visible = new_state == GameState.PLAYING
	if pause_menu:
		pause_menu.visible = new_state == GameState.PAUSED
	if game_over_menu:
		game_over_menu.visible = new_state == GameState.GAME_OVER

	_on_menu_opened(new_state)
	state_changed.emit(new_state)
	_on_state_changed(new_state)

func _on_menu_opened(state: GameState):
	match state:
		GameState.START:
			if start_menu and start_menu.has_method("on_opened"):
				start_menu.on_opened()

		GameState.PAUSED:
			if pause_menu and pause_menu.has_method("on_opened"):
				pause_menu.on_opened()

		GameState.GAME_OVER:
			if game_over_menu and game_over_menu.has_method("on_opened"):
				game_over_menu.on_opened()

func _on_state_changed(state : GameState):
	#if state == GameState.START:
		#audio_manager.play_music(start_menu_BGM)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if current_state != GameState.PLAYING and not get_tree().paused:
			return
		if get_tree().paused:
			resume_game()
		elif current_state == GameState.PLAYING:
			pause_game()

func start_game():
	set_state(GameState.PLAYING)

func pause_game():
	set_state(GameState.PAUSED)
	get_tree().paused = true

func resume_game():
	get_tree().paused = false
	set_state(GameState.PLAYING)

func trigger_game_over():
	set_state(GameState.GAME_OVER)
	get_tree().paused = true

func back_to_launcher():
	request_exit_to_launcher.emit()
	
