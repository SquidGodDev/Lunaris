extends Node2D

onready var _player = get_parent().get_node("Player")
var _parasite := preload("res://scenes/parasite/Parasite.tscn")
var rng = RandomNumberGenerator.new()

var _offset_array = [Vector2(-15, -15), Vector2(15, 15), Vector2(-15, 15), Vector2(15, -15)]

func _ready():
	Events.connect("start_chase_sequence", self, "_start_spawning")

func _start_spawning():
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	var _spawned_parasite = _parasite.instance()
	add_child(_spawned_parasite)
	var _offset = _offset_array[rng.randi_range(0, 3)]
	var _spawn_pos = _player.global_position - _offset
	_spawned_parasite.speed = 70
	_spawned_parasite.global_position = _spawn_pos
	_spawned_parasite.set_start_position(_spawn_pos)
