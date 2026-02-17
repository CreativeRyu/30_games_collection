extends CharacterBody2D

signal smashed(speed: float)

@export var slice_piece_scene: PackedScene
@export var fruit_splatter_szene: PackedScene
@export var juice_color: Color
@onready var sprite: Sprite2D = $Sprite2D
@onready var slice_detector: Area2D = $SliceDetector
@onready var score_system = get_tree().get_first_node_in_group("score_system")
@onready var audio = get_tree().get_first_node_in_group("audio_manager")

var gravity = 800.0
var rotation_speed = 120.0
const DESPAWN_Y = 1000

func _ready() -> void:
	slice_detector.area_entered.connect(on_slashed)
	velocity *= 0.99
	
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
	
	if global_position.y > DESPAWN_Y:
		queue_free()

func _process(delta):
	rotation_degrees += rotation_speed * delta

func launch(direction: Vector2, force: float):
	velocity = direction * force
	if audio:
		audio.play_fruit_launch()
	
func on_slashed(slash_direction, speed = 1.0):
	if score_system:
		score_system.add_score(1)
		
	emit_signal("smashed", speed)
	
	_play_slice_sound(speed)
	_spawn_juice(slash_direction)
	slice(slash_direction)	

func slice(slash_direction: Vector2):
	var tex = sprite.texture
	var size = tex.get_size()
	
	var horizontal_cut = abs(slash_direction.x) > abs(slash_direction.y)
	var perp = slash_direction.orthogonal().normalized()
	perp = perp.rotated(randf_range(-0.15, 0.15))
	var power = clamp(slash_direction.length(), 0.8, 1.2)
	
	if horizontal_cut:
		var top_rect = Rect2(0,0, size.x, size.y / 2)
		var bottom_rect = Rect2(0, size.y / 2, size.x, size.y /2)
		
		_spawn_piece(top_rect, perp * -180 * power +  Vector2(0, -250))
		_spawn_piece(bottom_rect, perp * 180 * power + Vector2(0, -250))
	else: 
		var left_rect = Rect2(0,0, size.x/2, size.y)
		var right_rect = Rect2(size.x/2, 0, size.x /2, size.y)

		_spawn_piece(left_rect, perp * -180 * power +  Vector2(0, -250))
		_spawn_piece(right_rect, perp * 180 * power + Vector2(0, -250))

	queue_free()

func _spawn_piece(region: Rect2, velocity: Vector2):
	var piece = slice_piece_scene.instantiate()
	piece.global_position = global_position
	get_parent().add_child(piece)
	
	piece.setup(sprite.texture, region, velocity)

func _play_slice_sound(speed):
	if audio:
		audio.play_fruit_slice(speed)

func _spawn_juice(direction: Vector2):
	if not fruit_splatter_szene:
		return
	
	var juice = fruit_splatter_szene.instantiate()
	juice.global_position = global_position
	get_parent().add_child(juice)
	juice.make_juice(direction, juice_color)
