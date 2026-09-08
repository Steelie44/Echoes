extends Node2D
class_name Bridge_2

const BRIDGE_SOUND: AudioStream = preload("res://assets/audio/bridge.wav")

@export var control_switch: Switch_2
@export var portal: LevelPortal
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
var is_down: bool = true

func _ready() -> void:
	audio_player.stream = BRIDGE_SOUND
	set_bridge_down()
	if portal:
		portal.set_active(false)

	if control_switch:
		control_switch.switched_on.connect(_on_switch_2_on)
		control_switch.switched_off.connect(_on_switch_2_off)

		if control_switch.is_on:
			raise_bridge()

func set_bridge_down() -> void:
	animation_player.play("down")
	animation_player.seek(animation_player.current_animation_length, true)
	is_down = true

func raise_bridge() -> void:
	if not is_down:
		return

	animation_player.play("up")
	audio_player.play()
	is_down = false
	
	await animation_player.animation_finished
	if portal and not is_down:
		portal.set_active(true)

func lower_bridge() -> void:
	if is_down:
		return
	if portal:
		portal.set_active(false)
	animation_player.play("down")
	audio_player.play()
	is_down = true

func _on_switch_2_on() -> void:
	raise_bridge()
	
func _on_switch_2_off() -> void:
	lower_bridge()
