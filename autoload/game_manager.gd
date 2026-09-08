extends Node

const LOADING_SCREEN := "res://scenes/ui/loading_screen.tscn"
const TITLE_SCREEN := "res://scenes/ui/title_screen.tscn"

signal loading_screen_revealed

@export var fade_duration := 0.5

var pending_scene_path := TITLE_SCREEN
var chamber_one_intro_seen := false
var transition_in_progress := false
var loading_screen_is_visible := false
var fade_layer: CanvasLayer
var fade_rect: ColorRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	fade_layer = CanvasLayer.new()
	fade_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	fade_layer.layer = 1000
	add_child(fade_layer)
	fade_rect = ColorRect.new()
	fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_rect.color = Color(0.0, 0.0, 0.0, 0.0)
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_rect.hide()
	fade_layer.add_child(fade_rect)

func start_new_game() -> void:
	chamber_one_intro_seen = false

func load_scene_with_hint(scene_path: String) -> void:
	if scene_path.is_empty() or transition_in_progress:
		push_warning("No destination scene was assigned")
		return
	transition_in_progress = true
	loading_screen_is_visible = false
	pending_scene_path = scene_path
	await _fade_to_black()
	get_tree().change_scene_to_file(LOADING_SCREEN)
	await get_tree().process_frame
	await _fade_from_black()
	loading_screen_is_visible = true
	loading_screen_revealed.emit()

func finish_loading() -> void:
	await _fade_to_black()
	get_tree().change_scene_to_file(pending_scene_path)
	await get_tree().process_frame
	await _fade_from_black()
	transition_in_progress = false

func wait_for_loading_screen() -> void:
	if loading_screen_is_visible:
		return
	await loading_screen_revealed

func _fade_to_black() -> void:
	fade_rect.show()
	fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(fade_rect, "color:a", 1.0, fade_duration)
	await tween.finished

func _fade_from_black() -> void:
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(fade_rect, "color:a", 0.0, fade_duration)
	await tween.finished
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_rect.hide()

func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.physical_keycode:
		KEY_1:
			Engine.time_scale = 1.0
		KEY_2:
			Engine.time_scale = 1.5
		KEY_3:
			Engine.time_scale = 2.0
