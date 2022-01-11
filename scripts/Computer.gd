extends Node2D

export(bool) var open_door = false
export(bool) var close_door = false
export(int) var open_door_index = -2
export(int) var close_door_index = -2

var _area_entered := false

func _ready():
	$InteractLabel.visible = false
	$SmokeParticles.emitting = false

func _input(event):
	if _area_entered and event.is_action_pressed("interact"):
		SoundManager.play_se("ComputerActivated")
		Events.emit_signal("computer_activated")
		_update_doors()
		$Area2D/CollisionShape2D.disabled = true
		$Tween.interpolate_property(self, "position", position, position + Vector2(0, 10), 2.5, Tween.TRANS_SINE, Tween.EASE_IN)
		$Tween.interpolate_property(self, "modulate:a", 1.0, 0.2, 2.5, Tween.TRANS_CIRC, Tween.EASE_IN)
		$SmokeParticles.emitting = true
		$Tween.start()

func _on_Area2D_body_entered(body):
	_area_entered = true
	$InteractLabel.visible = true

func _on_Area2D_body_exited(body):
	_area_entered = false
	$InteractLabel.visible = false

func _on_Tween_tween_all_completed():
	queue_free()

func _update_doors():
	if open_door:
		Events.emit_signal("open_door", open_door_index)
	if close_door:
		Events.emit_signal("close_door", close_door_index)
