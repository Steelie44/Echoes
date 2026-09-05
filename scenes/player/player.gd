extends CharacterBody2D

@export var speed: float = 200.0
@export var run_speed: float = 350.0
@export var jump_velocity: float = -400.0
@export var push_force: float = 100.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_direction := "r"
var playback_mode := false
var playback_frames: Array = []
var playback_index := 0
var echo_number := 0
var recorded_frames: Array = []
var activating_echo := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D


func configure_as_echo(frames: Array, number: int) -> void:
	playback_mode = true
	playback_frames = frames.duplicate(true)
	echo_number = number
	remove_from_group("Player")
	add_to_group("Echo")


func _ready() -> void:
	if playback_mode:
		camera.enabled = false
		animated_sprite.modulate = Color(0.35, 0.8, 1.0, 0.65)
	else:
		EchoManager.register_live_player(self)


func _physics_process(delta: float) -> void:
	if activating_echo:
		return

	var input_frame := _get_input_frame()
	if input_frame.is_empty():
		velocity = Vector2.ZERO
		return

	_apply_input_frame(input_frame, delta)
	if not playback_mode:
		recorded_frames.append(input_frame)


func _get_input_frame() -> Dictionary:
	if playback_mode:
		if playback_index >= playback_frames.size():
			return {}
		var frame: Dictionary = playback_frames[playback_index]
		playback_index += 1
		return frame

	return {
		"direction": Input.get_axis("left", "right"),
		"run": Input.is_action_pressed("run"),
		"jump": Input.is_action_just_pressed("jump"),
		"interact": Input.is_action_just_pressed("interact")
	}


func _apply_input_frame(input_frame: Dictionary, delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if input_frame.get("jump", false) and is_on_floor():
		velocity.y = jump_velocity

	var direction: float = input_frame.get("direction", 0.0)
	var is_running: bool = input_frame.get("run", false)
	var current_speed := run_speed if is_running else speed

	if direction != 0.0:
		velocity.x = direction * current_speed
		facing_direction = "l" if direction < 0.0 else "r"
	else:
		velocity.x = move_toward(velocity.x, 0.0, current_speed)

	update_animations(direction, is_running)
	move_and_slide()
	_push_bodies()

	if input_frame.get("interact", false):
		trigger_interaction()


func _push_bodies() -> void:
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		if body and body.is_in_group("Pushable"):
			body.apply_central_force(-collision.get_normal() * push_force)


func update_animations(direction: float, is_running: bool) -> void:
	if not is_on_floor():
		animated_sprite.play("jump_" + facing_direction)
	elif direction != 0.0:
		animated_sprite.play(("run_" if is_running else "walk_") + facing_direction)
	else:
		animated_sprite.play("walk_" + facing_direction)
		animated_sprite.pause()
		animated_sprite.frame = 0


func trigger_interaction() -> void:
	var closest: Node2D = null
	var closest_distance := 64.0

	for node in get_tree().get_nodes_in_group("Interactable"):
		if node is Node2D and node.has_method("interact"):
			var distance := global_position.distance_to(node.global_position)
			if distance <= closest_distance:
				closest = node
				closest_distance = distance

	if closest:
		closest.interact(self)


func _unhandled_input(event: InputEvent) -> void:
	if playback_mode or activating_echo:
		return
	if event.is_action_pressed("activate_echo"):
		_start_echo_activation()


func _start_echo_activation() -> void:
	if not EchoManager.can_create_echo():
		print("No echoes remaining")
		return

	activating_echo = true
	velocity = Vector2.ZERO
	animated_sprite.play("dead_" + facing_direction)
	await get_tree().create_timer(0.35).timeout
	EchoManager.activate_echo(recorded_frames)


func take_damage(_amount: float = 1.0) -> void:
	if playback_mode or activating_echo:
		return
	die_from_damage()


func die_from_damage() -> void:
	activating_echo = true
	velocity = Vector2.ZERO
	animated_sprite.play("hurt_" + facing_direction)
	await get_tree().create_timer(0.2).timeout
	animated_sprite.play("dead_" + facing_direction)
	await get_tree().create_timer(0.35).timeout
	EchoManager.lose_echo_to_damage()
