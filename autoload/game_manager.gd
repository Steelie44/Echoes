extends Node

const LOADING_SCREEN := "res://scenes/ui/loading_screen.tscn"
const TITLE_SCREEN := "res://scenes/ui/title_screen.tscn"

var pending_scene_path := TITLE_SCREEN


func load_scene_with_hint(scene_path: String) -> void:
	if scene_path.is_empty():
		push_warning("No destination scene was assigned")
		return

	pending_scene_path = scene_path
	get_tree().change_scene_to_file(LOADING_SCREEN)


func finish_loading() -> void:
	get_tree().change_scene_to_file(pending_scene_path)
