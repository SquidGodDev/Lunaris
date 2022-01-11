extends Area2D

var _checkpoint_activated := false

func _on_Checkpoint_body_entered(body):
	if !_checkpoint_activated:
		_checkpoint_activated = true
		Events.emit_signal("checkpoint_reached")
		GameManager.checkpoint_position = global_position
