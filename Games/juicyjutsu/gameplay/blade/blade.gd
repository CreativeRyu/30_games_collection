extends Node2D

@onready var trail: Line2D = $Line2D
@onready var blade_area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var audio = get_tree().get_first_node_in_group("audio_manager")

@export var max_points = 8
@export var min_distance = 2.0
@export var slash_speed_threshold = 600.0
@export var fade_speed = 40.0

var fading_out = false
var last_trail_position: Vector2 = Vector2.INF
var last_mouse_position: Vector2 = Vector2.INF
var current_slash_direction: Vector2 = Vector2.ZERO
var speed: float
var hit_something = false

func _ready():
	trail.clear_points()
	collision_shape.disabled = true
	blade_area.area_entered.connect(_on_area_entered)
	
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	var is_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	
	if is_pressed:
		fading_out = false
		_update_trail(mouse_position)
		_update_collision(mouse_position, delta)
		if last_mouse_position == Vector2.INF:
			hit_something = false
	else:
		collision_shape.disabled = true
		last_mouse_position = Vector2.INF
		fading_out = true
	
	_fade_trail(delta)

func _update_trail(position: Vector2):
	var local_mouse = to_local(position)
	
	if last_trail_position == Vector2.INF or last_trail_position.distance_to(local_mouse) > min_distance:
		trail.add_point(local_mouse)
		last_trail_position = local_mouse
	
	while trail.points.size() > max_points:
		trail.remove_point(0)

func _fade_trail(delta: float):
	if not fading_out:
		return
	
	var remove_count = int(fade_speed * delta)
	remove_count = max(remove_count, 1)
	
	for i in remove_count:
		if trail.points.size() > 0:
			trail.remove_point(0)
		else:
			fading_out = false
			last_trail_position = Vector2.INF
			break

func _update_collision(mouse_position: Vector2, delta: float):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		collision_shape.disabled = true
		last_mouse_position = Vector2.INF
		return
	
	if last_mouse_position == Vector2.INF:
		last_mouse_position = mouse_position
		collision_shape.disabled = true
		return
	
	speed = last_mouse_position.distance_to((mouse_position)) / delta
	var is_slashing = _is_slashing(speed)
	
	if collision_shape.disabled == is_slashing:
		collision_shape.disabled = not is_slashing
	
	if is_slashing:
		current_slash_direction = (mouse_position - last_mouse_position).normalized()
		_update_collision_shape(last_mouse_position, mouse_position)
		if audio:
			audio.play_blade_slash((mouse_position - last_mouse_position), speed)
	
	last_mouse_position = mouse_position

func _is_slashing(speed: float) -> bool:
	return speed > slash_speed_threshold

func _update_collision_shape(from: Vector2, to: Vector2):
	var center = (from + to) * 0.5
	blade_area.global_position = center
	
	var direction = to - from
	blade_area.rotation = direction.angle() # Slash Richtung
	
	var length = direction.length() # Slash Strecke
	
	var rect = collision_shape.shape as RectangleShape2D
	rect.size = Vector2(length, 7) # Klingenbreite

func _on_area_entered(other: Area2D):
	if collision_shape.disabled:
		return
	
	var target = other.get_parent()
	
	if target.has_method("on_slashed"):
		hit_something = true
		target.on_slashed(current_slash_direction, speed)
