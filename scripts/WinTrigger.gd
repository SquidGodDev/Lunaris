extends Area2D

var _triggered := false

func _on_WinTrigger_body_entered(_body):
	if !_triggered:
		_triggered = true
		SoundManager.play_se("Explosions")
		Events.emit_signal("change_scene", "res://scenes/UI/WinScreen.tscn")
