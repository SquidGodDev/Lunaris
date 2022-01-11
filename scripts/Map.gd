extends Node2D

var _play_chase_sequence := false

func _ready():
	Events.connect("start_dialog", self, "_start_dialog")
	Events.connect("start_chase_sequence", self, "_chase_sequence_dialog")
	SoundManager.play_bgm("SpaceAmbiance")

func _process(_delta):
	if !SoundManager.is_playing("SpaceAmbiance"):
		SoundManager.play_bgm("SpaceAmbiance")
	if _play_chase_sequence and !SoundManager.is_playing("SpaceAlarm"):
		SoundManager.play_bgs("SpaceAlarm")

func _start_dialog(timeline_input):
	var d = Dialogic.start(timeline_input)
	add_child(d)

func _chase_sequence_dialog():
	_play_chase_sequence = true
	var d = Dialogic.start("ChaseSequence")
	add_child(d)
