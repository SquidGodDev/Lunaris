extends Control


## The timeline to load when starting the scene
export(String, "TimelineDropdown") var timeline: String
export(bool) var add_canvas = true
export(bool) var reset_saves = true
export(bool) var debug_mode = false

func _ready():
	var d = Dialogic.start(timeline, '', "res://addons/dialogic/Nodes/DialogNode.tscn",  debug_mode, add_canvas)
	get_parent().call_deferred('add_child', d)

func _start_dialog(timeline_input):
	var d = Dialogic.start(timeline_input, '', "res://addons/dialogic/Nodes/DialogNode.tscn",  debug_mode, add_canvas)
	get_parent().call_deferred('add_child', d)
