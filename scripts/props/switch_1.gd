extends Area2D
class_name Switch_1

signal switched_on
signal switched_off

@export var starts_on: bool = false
@onready var green: Sprite2D = $Green
@onready var red: Sprite2D = $Red

var is_on: bool = false
var player_in_range: bool = false

func _ready() -> void:
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	set_switch_state(starts_on, false)

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		set_switch_state(not is_on)

func set_switch_state(new_state: bool, emit_signal: bool = true) -> void:
	is_on = new_state
	green.visible = is_on
	red.visible = not is_on
	if not emit_signal:
		return

	if is_on:
		switched_on.emit()
		print("Switch 1 is ON")
	else:
		switched_off.emit()
		print("Switch 1 is OFF")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
