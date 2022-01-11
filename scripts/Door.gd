extends Node2D

export var door_size := 3.0
export(bool) var close_on_pass = true
export(bool) var start_open = true
export(bool) var receive_signal = false
export(int) var door_index = -1

var _door_is_closed: bool

func _ready():
	Events.connect("open_door", self, "_try_open_door")
	Events.connect("close_door", self, "_try_close_door")
	$StaticBody2D.scale.y = 0
	$StaticBody2D/CollisionShape2D.disabled = true
	_door_is_closed = !start_open
	if !start_open:
		$StaticBody2D.scale.y = door_size

func _on_PlayerDetection_body_entered(_body):
	if close_on_pass and !_door_is_closed:
		SoundManager.play_se("Door")
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
		$PlayerDetection.queue_free()
		$Tween.interpolate_property($StaticBody2D, "scale:y", 0.0, door_size, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
		$Tween.start()

func _try_open_door(index):
	if receive_signal and (door_index == index):
		if _door_is_closed:
			_open_door()

func _try_close_door(index):
	if receive_signal and (door_index == index):
		if !_door_is_closed:
			_close_door()

func _open_door():
	SoundManager.play_se("Door")
	$Tween.interpolate_property($StaticBody2D, "scale:y", door_size, 0.0, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()

func _close_door():
	SoundManager.play_se("Door")
	$Tween.interpolate_property($StaticBody2D, "scale:y", 0.0, door_size, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()
