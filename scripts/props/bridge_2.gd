extends Node2D
class_name Bridge_2

@export var switch_1: Switch_2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_down: bool = true

func _ready() -> void:
	animation_player.play("up")
	animation_player.seek(animation_player.current_animation_length, true)
	is_down = false

	if switch_1:
		switch_1.switched_on.connect(_on_switch_1_on)
		switch_1.switched_off.connect(_on_switch_1_off)

		# Synchronize with the switch's current state.
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
	is_down = false

func lower_bridge() -> void:
	if is_down:
		return
	animation_player.play("down")
	is_down = true

func _on_switch_1_on() -> void:
	lower_bridge()
	
func _on_switch_1_off() -> void:
	raise_bridge()
