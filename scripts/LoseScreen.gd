extends Node2D

func _input(event):
	if event.is_action_pressed("interact"):
		Events.emit_signal("change_scene", "res://scenes/Map.tscn")
