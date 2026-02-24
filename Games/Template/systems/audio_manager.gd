extends Node

#@export var gameplay_sounds: Array[AudioStream]

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_container: Node = $SfxPool
@export var pool_size = 8
@export var sfx_library : Dictionary

func _ready() -> void:
	for i in range(pool_size):
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		sfx_container.add_child(player)

func play_music(stream: AudioStream):
	if music_player.stream == stream:
		return
	
	music_player.stop()
	music_player.stream = stream
	music_player.play()

func pause_music():
	if music_player.playing:
		music_player.stream_paused = true

func resume_music():
	if music_player.stream_paused:
		music_player.stream_paused = false

func stop_music():
	music_player.stop()
	music_player.stream = null

# Sounds später im Disctionary lagern und dynamisch bei Bedarf abspielen.
func play_sound(name: String):
	if not sfx_library.has(name):
		return
	
	play_sfx(sfx_library[name])

func play_sfx(stream: AudioStream, pitch= 1.0, volume_db= 0.0):
	var sfx_player = _get_free_player()
	if sfx_player == null:
		return
	
	sfx_player.stream = stream
	sfx_player.pitch_scale = pitch
	sfx_player.volume_db = volume_db
	sfx_player.play()

func _get_free_player() -> AudioStreamPlayer:
	for player in sfx_container.get_children():
		if player is AudioStreamPlayer and not player.playing:
			return player
			
	if sfx_container.get_child_count() > 0:
		return sfx_container.get_children()[0] as AudioStreamPlayer

	return null
