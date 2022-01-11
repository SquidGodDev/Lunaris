extends ColorRect

var _transitioning := false

func _ready():
	modulate.a = 1.0
	if get_tree().get_current_scene().get_name() == "WinScreen":
		color = Color.white
	else:
		color = Color.black
	Events.connect("change_scene", self, "_switch_scene")
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

func _switch_scene(scene):
	if !_transitioning:
		if scene == "res://scenes/UI/WinScreen.tscn":
			color = Color.white
		else:
			color = Color.black
		_transitioning = true
		$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween, "tween_all_completed")
		get_tree().change_scene(scene)
