extends Node2D

@export var camera: Camera2D

var shake_strength = 0.0
var shake_decay = 10.0

func shake(amount: float):
	shake_strength = max(shake_strength, amount)

func _process(delta):
	if shake_strength > 0.0:
		shake_strength = max(shake_strength - shake_decay * delta, 0.0)
		var offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_strength
		
		camera.offset = offset
	else:
		camera.offset = Vector2.ZERO
