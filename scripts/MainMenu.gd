extends Node2D

func _input(event):
	if event.is_action_pressed("interact"):
		SoundManager.play_se("GameStart")
		Events.emit_signal("change_scene", "res://scenes/Map.tscn")
