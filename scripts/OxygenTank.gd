extends Control

export var oxygen_loss_rate := 1.0
export var oxygen_gain_rate := 10.0

var _parasites_attached := 0
var _parasite_loss_multiplier := 1.0
var _max_oxygen := 100.0
var _gaining_oxygen := false

var _player_died := false

onready var _oxygen_progress_bar: ProgressBar = $ProgressBar
onready var _vignette = get_parent().get_node("Vignette")

func _ready():
	_oxygen_progress_bar.max_value = _max_oxygen
	_oxygen_progress_bar.value = _max_oxygen
	Events.connect("oxygen_station_entered", self, "_on_oxygen_station_entered")
	Events.connect("oxygen_station_exited", self, "_on_oxygen_station_exited")
	Events.connect("parasite_attached", self, "_increment_parasites_attached")
	Events.connect("parasite_detached", self, "_decrement_parasites_attached")

func _physics_process(delta):
	if _player_died:
		return
		
	if _gaining_oxygen:
		_oxygen_progress_bar.value += oxygen_gain_rate * delta
	else:
		_oxygen_progress_bar.value -= (oxygen_loss_rate + _parasites_attached * _parasite_loss_multiplier) * delta
		
	var oxygen_value = _oxygen_progress_bar.value
	if oxygen_value <= 50:
		_vignette.visible = true
		_vignette.material.set_shader_param("multiplier", ((50-oxygen_value) / 50) * -3 + 1)
	else:
		_vignette.visible = false
	
	if oxygen_value <= 30 or _parasites_attached != 0:
		if !SoundManager.is_playing("HeavyBreathing"):
			SoundManager.play_se("HeavyBreathing", 0.0, 3.0)
		if !SoundManager.is_playing("OxygenWarning"):
			SoundManager.play_se("OxygenWarning", 0.0, -10.0)
	
	if oxygen_value <= 0:
		Events.emit_signal("player_died")
		Events.emit_signal("change_scene", "res://scenes/UI/LoseScreen.tscn")
		_player_died = true

func _on_oxygen_station_entered():
	_gaining_oxygen = true
	
func _on_oxygen_station_exited():
	_gaining_oxygen = false
	
func _increment_parasites_attached():
	_parasites_attached += 1

func _decrement_parasites_attached():
	_parasites_attached -= 1
	if _parasites_attached <= 0:
		_parasites_attached = 0
