extends Node

@export var fruit_slice_sounds: Array[AudioStream]
@export var blade_sounds_horizontal: Array[AudioStream]
@export var blade_sounds_vertical: Array[AudioStream]
@export var blade_sounds_diagonal: Array[AudioStream]
@export var fruit_launch_sounds: Array[AudioStream]
@export var bomb_launch_sounds: Array[AudioStream]

@onready var music: AudioStreamPlayer2D = $MusicPlayer
@onready var sfx: AudioStreamPlayer2D = $SfxPlayer
@onready var blade_player: AudioStreamPlayer2D = $BladePlayer
@onready var fruit_slice_player: AudioStreamPlayer2D = $FruitSlicePlayer
@onready var fruit_launch_player: AudioStreamPlayer2D = $FruitLaunchPlayer
@onready var bomb_player: AudioStreamPlayer2D = $BombPlayer

func play_music(stream: AudioStream):
	if music.stream == stream:
		return
	
	music.stop()
	music.stream = stream
	music.play()

func pause_music():
	if music.playing:
		music.stream_paused = true

func resume_music():
	if music.stream_paused:
		music.stream_paused = false

func stop_music():
	music.stop()
	music.stream = null

func play_sfx(stream: AudioStream):
	sfx.stream = stream
	sfx.play()

func play_fruit_slice(speed):
	if fruit_slice_sounds.is_empty():
		return
	fruit_slice_player.stream = fruit_slice_sounds.pick_random()
	fruit_slice_player.pitch_scale = clamp(speed/ 800.0, 0.9, 1.3)
	fruit_slice_player.play()

func play_button_pressed():
	sfx.stream = preload("res://Games/juicyjutsu/audio/sfx/button_pressed.mp3")
	sfx.play()

func play_blade_slash(direction: Vector2, speed: float):
	var sounds: Array[AudioStream]
	
	var dir = direction.normalized()
	var abs_x = abs(dir.x)
	var abs_y = abs(dir.y)
	
	if abs_x > 0.8:
		sounds = blade_sounds_horizontal
	elif abs_y > 0.8:
		sounds = blade_sounds_vertical
	else:
		sounds = blade_sounds_diagonal
	
	if sounds.is_empty():
		return
	
	blade_player.stream = sounds.pick_random()
	blade_player.pitch_scale = clamp(speed/ 800.0, 0.9, 1.3)
	blade_player.volume_db = lerp(-8.0, 0.0, clamp(speed/1200.0, 0.0, 1.0))
	blade_player.play()

	
func play_fruit_launch():
	if fruit_launch_sounds.is_empty():
		return
		
	fruit_launch_player.stream = fruit_launch_sounds.pick_random()
	fruit_launch_player.pitch_scale = randf_range(0.9, 1.1)
	fruit_launch_player.volume_db = -1
	fruit_launch_player.play()

func play_bomb_launch():
	if bomb_launch_sounds.is_empty():
		return
	
	bomb_player.stream = bomb_launch_sounds.pick_random()
	bomb_player.pitch_scale = randf_range(0.95, 1.05)
	bomb_player.volume_db = -4
	bomb_player.play()
