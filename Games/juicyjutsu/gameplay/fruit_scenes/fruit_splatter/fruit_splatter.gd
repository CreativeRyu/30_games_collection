extends Node2D

@onready var particles: GPUParticles2D = $GPUParticles2D
@export var juice_textures: Array[Texture2D]

func make_juice(direction: Vector2, color: Color):
	var material := particles.process_material as ParticleProcessMaterial
	
	if not juice_textures.is_empty():
		particles.texture = juice_textures.pick_random()
		
	# Richtung
	material.direction = Vector3(direction.x, direction.y, 0).normalized()
	
	# Farbe
	material.color = color
	
	# One-shot korrekt neu starten
	particles.emitting = false
	particles.restart()
	particles.emitting = true
	
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
