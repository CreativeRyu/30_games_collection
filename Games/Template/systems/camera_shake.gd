class_name CameraShake
extends Node2D

@export var decay_speed = 12.0
@export var noise_speed = 30.0
@export var max_strength = 30.0

var shake_strength = 0.0
var noise = FastNoiseLite.new()
var noise_time = 0.0

var camera: Camera2D

func _ready() -> void:
	camera = get_node_or_null("Camera2D")
	if camera == null:
		push_warning("CameraShake: No Camera2D found.")
	
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()

func shake(amount: float):
	shake_strength = clamp(max(shake_strength, amount), 0, max_strength)

func _process(delta):
	if camera == null:
		return
	if shake_strength > 0.0:
		shake_strength = max(shake_strength - decay_speed * delta, 0.0)
		
		noise_time += delta * noise_speed
		var x = noise.get_noise_1d(noise_time)
		var y = noise.get_noise_1d(noise_time + 1000)
		
		camera.offset = Vector2(x,y) * shake_strength
		set_process(true)
	else:
		camera.offset = Vector2.ZERO
		set_process(false)

func _enter_tree() -> void:
	if camera:
		camera.offset = Vector2.ZERO
