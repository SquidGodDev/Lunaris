extends KinematicBody2D

const UP_DIRECTION := Vector2.UP

export var speed := 100.0

export var jump_strength := 190.0
export var maximum_jumps := 2
export var double_jump_strength := 210.0
export var gravity := 300.0

var _jumps_made := 0
var _velocity := Vector2.ZERO

var _just_entered_oxygen_station := false

var _in_air = false
var _is_dead = false
var _played_death = false

onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _oxygen_tank = get_parent().get_node("CanvasLayer/OxygenTank")

func _ready():
	Events.connect("oxygen_station_entered", self, "_disable_movement_on_oxygen_station_enter")
	Events.connect("player_died", self, "_death")
	if GameManager.checkpoint_position:
		global_position = GameManager.checkpoint_position

func _physics_process(delta: float) -> void:
	if _is_dead:
		if !_played_death:
			SoundManager.play_se("Lose")
			$AnimationPlayer.play("Die")
			_played_death = true
		return

	var _horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	if _just_entered_oxygen_station:
		if is_zero_approx(_horizontal_direction):
			_just_entered_oxygen_station = false
		else:
			return
	
	_velocity.x = _horizontal_direction * speed
	_velocity.y += gravity * delta
	
	var is_falling := _velocity.y > 0.0 and not is_on_floor()
	var is_jumping := Input.is_action_just_pressed("jump") and is_on_floor()
	var is_double_jumping := Input.is_action_just_pressed("jump") and not is_on_floor()
	var is_idling := is_on_floor() and is_zero_approx(_velocity.x)
	var is_running := is_on_floor() and not is_zero_approx(_velocity.x)
	
	if is_jumping:
		_jumps_made += 1
		_velocity.y = -jump_strength
		SoundManager.play_se("Jump", 0.0, -20.0)
	elif is_double_jumping:
		_jumps_made += 1
		if _jumps_made <= maximum_jumps:
			SoundManager.play_se("DoubleJump", 0.0, -20.0)
			_velocity.y = -double_jump_strength
	elif is_idling or is_running:
		_jumps_made = 0
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
	
	if not is_zero_approx(_velocity.x):
		if _velocity.x < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	
	if is_jumping:
		_animation_player.play("Jump")
		_in_air = true
	elif is_double_jumping:
		_animation_player.play("Jump")
		_in_air = true
	elif is_running:
		_animation_player.play("Run")
		if _in_air:
			_in_air = false
			SoundManager.play_se("Landing")
	elif is_falling:
		_animation_player.play("Fall")
		_in_air = true
	elif is_idling:
		_animation_player.play("Idle")
		if _in_air:
			_in_air = false
			SoundManager.play_se("Landing")

func _disable_movement_on_oxygen_station_enter():
	var _horizontal_direction = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	$Sprite.flip_h = false
	_velocity = Vector2.ZERO
	_animation_player.play("Idle")
	if not is_zero_approx(_horizontal_direction):
		_just_entered_oxygen_station = true

func _death():
	_is_dead = true

func _play_run_sfx():
	SoundManager.play_se("Walk")
