extends Area2D

export(int) var x_inset = 5
export(int) var y_inset = 5
export(int) var max_parasites = 5

var _parasite := preload("res://scenes/parasite/Parasite.tscn")

onready var _spawn_area_extents: Vector2 = $CollisionShape2D.shape.get_extents()

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _spawn_parasite():
	var _spawned_parasite = _parasite.instance()
	$ParasiteList.add_child(_spawned_parasite)
	var _rand_pos = _get_rand_position()
	_spawned_parasite.global_position = _rand_pos
	_spawned_parasite.set_start_position(_rand_pos)

func _get_rand_position():
	var _max_y = global_position.y + _spawn_area_extents.y - y_inset * 8
	var _min_y = global_position.y - _spawn_area_extents.y + y_inset * 8
	var _max_x = global_position.x + _spawn_area_extents.x - x_inset * 8
	var _min_x = global_position.x - _spawn_area_extents.x + x_inset * 8
	return Vector2(rng.randf_range(_min_x, _max_x), rng.randf_range(_min_y, _max_y))

func _on_SpawnTimer_timeout():
	if $ParasiteList.get_child_count() < max_parasites:
		_spawn_parasite()

func _on_ParasiteSpawner_body_entered(_body):
	$SpawnTimer.start()
