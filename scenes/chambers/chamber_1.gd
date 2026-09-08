extends Node2D

const AMBIENT_EARTH_MAIN = preload("uid://c724gprtdpojb")
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EchoManager.ensure_capacity_for_chamber(1)
	audio_player.stream = AMBIENT_EARTH_MAIN
	EchoManager.play_level_music(audio_player)


func _process(delta: float) -> void:
	pass
