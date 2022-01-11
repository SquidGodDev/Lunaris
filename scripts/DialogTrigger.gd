extends Area2D

export(String, "TimelineDropdown") var timeline: String

var _dialog_triggered := false

func _on_DialogTrigger_body_entered(_body):
	if !_dialog_triggered:
		_dialog_triggered = true
		Events.emit_signal("start_dialog", timeline)
