extends Control

@export var launcher_scene : PackedScene
@export var in_time: float = 0.5
@export var fade_in_time: float = 1.5
@export var pause_time: float = 1.5
@export var fade_out_time: float = 1.5
@export var out_time: float = 1.5
@export var splash_screen: TextureRect

@export var splash_color : Color = Color("#192027")
@export var launcher_color : Color = Color("#4d4d4d")

@onready var background: ColorRect = $ColorRect
@onready var launcher_holder: Control = $LauncherHolder

func _ready():
	if launcher_scene == null:
		push_error("Launcher Scene missing!")
		return
	background.color = splash_color

	var launcher = launcher_scene.instantiate()
	launcher_holder.add_child(launcher)

	# erstmal unsichtbar
	launcher_holder.modulate.a = 0.0
	await _play_splash()
	
func _play_splash() -> void:
	splash_screen.modulate.a = 0.0
	var tween = self.create_tween()
	tween.tween_interval(in_time)
	tween.tween_property(splash_screen, "modulate:a", 1.0, fade_in_time)
	tween.tween_interval(pause_time)
	# Parallel:
	tween.tween_property(splash_screen, "modulate:a", 0.0, fade_out_time)
	# Background zur Launcher Farbe tweenen
	tween.tween_property(background, "color", launcher_color, fade_out_time)
	tween.set_parallel(true)
	# Launcher reinfaden
	tween.tween_property(launcher_holder,"modulate:a",1.0,fade_out_time)
	tween.tween_interval(out_time)
	await tween.finished
