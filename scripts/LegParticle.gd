extends Particles2D

export(Vector2) var direction = Vector2(1, 0)
export(float) var max_spread = 0.5
export(float) var _move_time_variance = 0.5
export(float) var _median_move_time = 1.0

var _current_spread := 0.0
var _leg_down = true

var rng = RandomNumberGenerator.new()

func _ready():
	process_material.set("direction", Vector3(direction.x, direction.y, 0))
	rng.randomize()
	$Tween.interpolate_property(self, "_current_spread", _current_spread, max_spread, _get_random_move_time(), Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()

func _physics_process(_delta):
	if direction.y == 0:
		process_material.set("direction", Vector3(direction.x, direction.y + _current_spread, 0))
	else:
		process_material.set("direction", Vector3(direction.x + _current_spread, direction.y, 0))

func _on_Tween_tween_all_completed():
	var _spread_multiplier = 1
	if _leg_down:
		_spread_multiplier = -1
		_leg_down = false
	else:
		_leg_down = true
	
	$Tween.interpolate_property(self, "_current_spread", _current_spread, _spread_multiplier * max_spread, _get_random_move_time(), Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Tween.start()

func _get_random_move_time():
	return rng.randf_range(_median_move_time - _move_time_variance, _median_move_time + _move_time_variance)
