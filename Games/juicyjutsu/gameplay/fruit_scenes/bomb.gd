extends CharacterBody2D

@onready var slice_detector: Area2D = $SliceDetector
@onready var animation: AnimationPlayer = $AnimationPlayer

var gravity = 1000.0
var rotation_speed = 120.0
const DESPAWN_Y = 1000

signal exploded

func _ready() -> void:
	animation.play()
	slice_detector.area_entered.connect(on_slashed)
	
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
	
	if global_position.y > DESPAWN_Y:
		queue_free()

func _process(delta):
	rotation_degrees += rotation_speed * delta

func launch(direction: Vector2, force: float):
	velocity = direction * force
	
	var audio = get_tree().get_first_node_in_group("audio_manager")
	if audio:
		audio.play_bomb_launch()

func on_slashed(_unused_direction, speed):
	explode()

func explode():
	# eventuell hier noch eine animation spielen und dann exploded emitten auslösen
	slice_detector.set_deferred("monitoring", false)
	exploded.emit()
	queue_free()
