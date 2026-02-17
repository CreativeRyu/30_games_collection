extends Node2D

signal fruit_spawned(fruit)
signal burst_spawned(intensity: float)

@export var burst_chance = 0.25
@export var burst_min = 2
@export var burst_max = 4
@export var burst_delay_min = 0.35
@export var burst_delay_max = 0.6
@export var burst_force_multiplier = 1.10

@export var spawn_table:= [
	{ "scene": null, "weight": 4 },
	{ "scene": null, "weight": 4 },
	{ "scene": null, "weight": 3 },
	{ "scene": null, "weight": 1 },
	{ "scene": null, "weight": 2 },
	{ "scene": null, "weight": 5 },
	{ "scene": null, "weight": 3 },
	{ "scene": null, "weight": 4 },
	{ "scene": null, "weight": 1 },
	{ "scene": null, "weight": 2 }
]
@export var spawn_interval = 1.2
@onready var spawn_points = $SpawnPoints.get_children()
@onready var spawn_timer: Timer = $SpawnTimer
@onready var score_system = get_tree().get_first_node_in_group("score_system")

var is_active = false

func _ready():
	randomize()
	spawn_timer.timeout.connect(spawn_fruit)
	spawn_timer.wait_time = spawn_interval

func start():
	spawn_timer.start()
	is_active = true

func stop():
	spawn_timer.stop()
	is_active = false

# Richtung für Abschuss berechnen
func _get_launch_direction(spawn_point: Node2D) -> Vector2:
	var angle = 0.0
	
	if spawn_point.is_in_group("spawn_left"):
		return Vector2(1, -0.7).normalized()
	elif spawn_point.is_in_group("spawn_right"):
		return Vector2(-1, -0.7).normalized()
	elif spawn_point.is_in_group("spawn_bottom"):
		if spawn_point.name == "SpawnCenterRight":
			angle = randf_range(-0.30, -0.15)
		elif spawn_point.name == "SpawnCenterLeft":
			angle = randf_range(0.15, 0.30)
		else:
			angle = 0.0
	
	return Vector2.UP.rotated(angle)

# Force zum Abschuss berechnen
func _get_launch_force(spawn_point: Node2D) -> float:
	if spawn_point.is_in_group("spawn_bottom"):
		return randf_range(650, 770)
	elif spawn_point.is_in_group("spawn_right") or spawn_point.is_in_group("spawn_left"):
		return randf_range(450, 650) 
	return randf_range(600, 800)

func _pick_weighted_scene() -> PackedScene:
	var total_weight = 0
	for element in spawn_table:
		if element.scene == null:
			continue
		total_weight += element.weight
	
	var roll = randi() % total_weight
	var current_weight = 0
	
	for element in spawn_table:
		if element.scene == null:
			continue
		current_weight += element.weight
		if roll < current_weight:
			return element.scene
		
	return null
	
func _get_current_burst_chance() -> float:
	var time_left = score_system.time_left
	var total_time = score_system.round_time
	
	var progress = 1.0 - (time_left / total_time)
	return lerp(0.0, 0.8, progress)

func _get_burst_count() -> int:
	if not score_system:
		return randi_range(burst_min, burst_max)
		
	var time_left = score_system.time_left
	var total_time = score_system.round_time
	# Anfang: sanft
	if time_left > total_time - 5.0:
		return 2
	# Endgame: maximaler Druck
	if time_left <= 10.0:
		return randi_range(4, 6)
	# Midgame
	return randi_range(3, 4)
	
func spawn_fruit():
	if spawn_table.is_empty() or spawn_points.is_empty():
		return
	
	if randf() < _get_current_burst_chance():
		_spawn_burst()
	else:
		_spawn_single()

# Spawn einer einzelnen Frucht
func _spawn_single():
	var spawn_point = spawn_points.pick_random()
	var direction = _get_launch_direction(spawn_point)
	direction = direction.rotated(randf_range(-0.15, 0.15))
	var force = _get_launch_force(spawn_point)
	
	_spawn_fruit_from_point(spawn_point, direction, force)

# Burst Fruit Spawn
func _spawn_burst():
	var count = _get_burst_count()
	var spawn_point = spawn_points.pick_random()
	var base_direction = _get_launch_direction(spawn_point)
	var base_force = _get_launch_force(spawn_point) * burst_force_multiplier
	
	var shake_intensity = clamp(count * 1.5, 3.0, 10.0)
	burst_spawned.emit(shake_intensity * 0.8)
	
	for i in count:
		var direction = base_direction.rotated(randf_range(-0.2, 0.2))
		var force = base_force * randf_range(0.9, 1.1)
		
		_spawn_fruit_from_point(spawn_point, direction, force)
		
		await get_tree().create_timer(randf_range(burst_delay_min, burst_delay_max)).timeout

# Instantiierung der Frucht
func _spawn_fruit_from_point(spawn_point: Node2D, direction: Vector2, force: float):
	var scene = _pick_weighted_scene()
	if scene == null:
		return
	
	var fruit = scene.instantiate()
	get_parent().add_child(fruit)
	fruit.global_position = spawn_point.global_position
	
	fruit.launch(direction, force)
	fruit_spawned.emit(fruit)
