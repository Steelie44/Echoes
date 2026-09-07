extends Node2D
class_name Switch_3

signal switched_on
signal switched_off

@export var starts_on: bool = false
@onready var green: Sprite2D = $Green
@onready var red: Sprite2D = $Red

var is_on: bool = false

func _ready() -> void:
	set_switch_state(starts_on, false)

func interact(_actor: Node2D = null) -> void:
	set_switch_state(not is_on)

func set_switch_state(new_state: bool, emit_signal: bool = true) -> void:
	is_on = new_state
	green.visible = is_on
	red.visible = not is_on
	if not emit_signal:
		return

	if is_on:
		switched_on.emit()
		print("Switch 3 is ON")
	else:
		switched_off.emit()
		print("Switch 3 is OFF")
