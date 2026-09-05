extends Node

const PLAYER_SCENE := preload("res://scenes/player/player.tscn")
const MAX_ECHOES := 3
const SLOT_EMPTY := 0
const SLOT_ACTIVE := 1
const SLOT_DIED := 2

signal resources_changed(slot_states: Array)
signal out_of_echoes

var recordings: Array[Array] = []
var slot_states: Array[int] = [SLOT_EMPTY, SLOT_EMPTY, SLOT_EMPTY]
var reload_pending := false


func can_create_echo() -> bool:
	return _next_empty_slot() != -1


func echoes_remaining() -> int:
	return slot_states.count(SLOT_EMPTY)


func activate_echo(recording: Array) -> void:
	var slot := _next_empty_slot()
	if slot == -1 or recording.is_empty():
		return

	slot_states[slot] = SLOT_ACTIVE
	recordings.append(recording.duplicate(true))
	resources_changed.emit(slot_states.duplicate())
	_reload_level()


func lose_echo_to_damage() -> void:
	var slot := _next_empty_slot()
	if slot == -1:
		out_of_echoes.emit()
		print("Game over: no echo resources remaining")
		return

	slot_states[slot] = SLOT_DIED
	resources_changed.emit(slot_states.duplicate())
	_reload_level()


func _reload_level() -> void:
	reload_pending = true
	get_tree().reload_current_scene()


func register_live_player(player: CharacterBody2D) -> void:
	var spawn_position := get_tree().current_scene.get_node_or_null("SpawnPosition")
	if spawn_position is Marker2D:
		player.global_position = spawn_position.global_position
	else:
		push_warning("Current level has no SpawnPosition Marker2D")

	if not reload_pending:
		return

	reload_pending = false
	call_deferred("_spawn_recorded_echoes", player)


func _spawn_recorded_echoes(player: CharacterBody2D) -> void:
	if not is_instance_valid(player):
		return

	var echo_parent := player.get_parent()
	var spawned_echoes: Array[CharacterBody2D] = []
	for index in recordings.size():
		var echo: CharacterBody2D = PLAYER_SCENE.instantiate()
		echo.configure_as_echo(recordings[index], index + 1)
		echo_parent.add_child(echo)
		echo.global_position = player.global_position

		# All actors begin on the same marker. Prevent physics from pushing
		# overlapping players/echoes into nearby level geometry.
		echo.add_collision_exception_with(player)
		player.add_collision_exception_with(echo)
		for other_echo in spawned_echoes:
			echo.add_collision_exception_with(other_echo)
			other_echo.add_collision_exception_with(echo)

		spawned_echoes.append(echo)


func reset_echoes() -> void:
	recordings.clear()
	slot_states = [SLOT_EMPTY, SLOT_EMPTY, SLOT_EMPTY]
	reload_pending = false
	resources_changed.emit(slot_states.duplicate())


func _next_empty_slot() -> int:
	for index in slot_states.size():
		if slot_states[index] == SLOT_EMPTY:
			return index
	return -1
