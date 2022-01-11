extends KinematicBody2D

export var speed = 100
export var wander_speed = 20
export var stop_distance = 30

onready var soft_collision = $SoftCollision

var _player_body: KinematicBody2D

onready var _start_position := global_position
onready var _target_position := global_position
var _wander_range := 20

var _direction: Vector2 = Vector2.ZERO

var _play_audio = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	Events.connect("oxygen_station_entered", self, "_die")
	randomize()
	rng.randomize()
	_update_random_position()
	$BlinkTimer.start(rng.randf_range(2.0, 4.0))
	$SquelchTimer.start(rng.randf_range(0.0, 1.0))
	scale = Vector2.ZERO
	$SpawnTween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$SpawnTween.start()

func set_start_position(position):
	_start_position = position

func _physics_process(_delta):
	var velocity = Vector2.ZERO
	if _player_body:
		if global_position.distance_squared_to(_player_body.global_position) <= stop_distance:
			_direction = Vector2.ZERO
		else:
			_direction = global_position.direction_to(_player_body.global_position).normalized()
		velocity = _direction * speed
	else:
		if global_position.distance_squared_to(_target_position) <= 3.0:
			_direction = Vector2.ZERO
		else:
			_direction = global_position.direction_to(_target_position).normalized()
		velocity = _direction * wander_speed
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * 50
	move_and_slide(velocity)

func _die():
	if _player_body:
		$SquelchTimer.stop()
		SoundManager.stop("Squelch")
		SoundManager.play_se("ParasiteDeath")
		$DeathParticles.emitting = true
		$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 1, Tween.TRANS_QUAD, Tween.EASE_IN)
		$Tween.interpolate_property($Sprite, "scale", Vector2(1.0, 1.0), Vector2.ZERO, 1, Tween.TRANS_QUAD, Tween.EASE_IN)
		$Tween.start()
		yield($Tween,"tween_all_completed")
		queue_free()

func _on_PlayerDetectionArea_body_entered(body):
	if !_player_body:
		SoundManager.play_se("ParasiteNotice")
	_player_body = body

func _on_DamageCollision_body_entered(_body):
	Events.emit_signal("parasite_attached")

func _on_DamageCollision_body_exited(_body):
	Events.emit_signal("parasite_detached")
	
func _get_random_normalized_vector():
	return Vector2(rng.randf_range(-_wander_range, _wander_range), rng.randf_range(-_wander_range, _wander_range))

func _on_WanderTimer_timeout():
	_update_random_position()
	$WanderTimer.start(rng.randf_range(1.0, 3.0)) 
	
func _update_random_position():
	var _target_vector = _get_random_normalized_vector()
	_target_position = _start_position + _target_vector

func _on_BlinkTimer_timeout():
	$AnimationPlayer.play("Blink")
	if _play_audio:
		SoundManager.play_se("Blink")
	$BlinkTimer.start(rng.randf_range(2.0, 4.0))

func _on_SquelchTimer_timeout():
	if _play_audio:
		SoundManager.play_se("Squelch")
	$SquelchTimer.start(rng.randf_range(2.0, 3.0))

func _on_AudioDetectionArea_body_entered(_body):
	_play_audio = true

func _on_AudioDetectionArea_body_exited(_body):
	_play_audio = false
