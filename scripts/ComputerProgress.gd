extends Control

export var computer_total := 10
var _computers_activated := 0

func _ready():
	Events.connect("computer_activated", self, "_increment_computers_activated")
	Events.connect("checkpoint_reached", self, "_update_game_manager_progress")
	_computers_activated = GameManager.computers_activated
	_update_progress_label()

func _increment_computers_activated():
	_computers_activated += 1
	if _computers_activated == computer_total:
		Events.emit_signal("start_chase_sequence")
	_update_progress_label()

func _update_progress_label():
	$ProgressLabel.text = String(_computers_activated) + " / " + String(computer_total)

func _update_game_manager_progress():
	GameManager.computers_activated = _computers_activated
