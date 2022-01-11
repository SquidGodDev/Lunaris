extends Node2D

var _play_oxygen_hiss := false

func _physics_process(_delta):
	if _play_oxygen_hiss and !SoundManager.is_playing("OxygenHiss"):
		SoundManager.play_se("OxygenHiss", 0.0, -10.0)

func _on_Area2D_body_entered(body):
	body.set_deferred("global_position", $SnapPoint.global_position)
	SoundManager.play_se("OxygenStart")
	_play_oxygen_hiss = true
	Events.emit_signal("oxygen_station_entered")

func _on_Area2D_body_exited(_body):
	Events.emit_signal("oxygen_station_exited")
	_play_oxygen_hiss = false
	SoundManager.stop("OxygenHiss")
