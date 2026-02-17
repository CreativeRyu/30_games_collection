extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

var velocity = Vector2.ZERO
var angular_velocity = 0.0
var gravity = 800.0

func setup(texture: Texture2D, region: Rect2, start_velocity: Vector2):
	sprite.texture = texture
	sprite.region_enabled = true
	sprite.region_rect = region
	
	velocity = start_velocity
	angular_velocity = randf_range(-3.0, 3.0)

func _process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation += angular_velocity * delta
	
	velocity *= 0.99
	angular_velocity *= 0.98
	
	# Auto Cleanup
	if position.y > 1000:
		queue_free()
