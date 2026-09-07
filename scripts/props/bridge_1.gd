extends Node2D
class_name Bridge_1

const BRIDGE_SOUND: AudioStream = preload("res://assets/audio/bridge.wav")
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

#@onready var portal: LevelPortal = $"../Portal"
@export var switch_1: Switch_1
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_down: bool = true

func _ready() -> void:
	audio_player.stream = BRIDGE_SOUND
	animation_player.play("up")
	animation_player.seek(animation_player.current_animation_length, true)
	#portal.set_active(false)
	is_down = false

	if switch_1:
		switch_1.switched_on.connect(_on_switch_1_on)
		switch_1.switched_off.connect(_on_switch_1_off)

		if switch_1.is_on:
			raise_bridge()

func set_bridge_down_immediately() -> void:
	animation_player.play("down")
	animation_player.seek(
		animation_player.current_animation_length,
		true
	)
	is_down = true

func raise_bridge() -> void:
	if not is_down:
		return
	animation_player.play("up")
	audio_player.play()
	#portal.set_active(false)
	is_down = false

func lower_bridge() -> void:
	if is_down:
		return
	animation_player.play("down")
	audio_player.play()
	is_down = true
	await animation_player.animation_finished
	#if is_down:
		#portal.set_active(true)

func _on_switch_1_on() -> void:
	lower_bridge()
	
func _on_switch_1_off() -> void:
	raise_bridge()
