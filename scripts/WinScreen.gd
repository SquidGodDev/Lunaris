extends Node2D

func _ready():
	SoundManager.play_se("WinSound")
	SoundManager.stop("SpaceAmbiance")

func _input(event):
	if event.is_action_pressed("interact"):
		GameManager.computers_activated = 0
		GameManager.checkpoint_position = null
		Events.emit_signal("change_scene", "res://scenes/UI/MainMenu.tscn")
