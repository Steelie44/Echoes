extends Control

@export var display_time := 3.0
@onready var hint_label: Label = $AspectRatioContainer/Label
@onready var chamber_number: RichTextLabel = $ChamberNumber


func _ready() -> void:
	_update_chamber_name()
	var hints := Hints.new()
	if not hints.hint_list.is_empty():
		hint_label.text = "Hint: " + hints.hint_list.pick_random()
	hints.queue_free()

	await GameManager.wait_for_loading_screen()
	await get_tree().create_timer(display_time).timeout
	GameManager.finish_loading()


func _update_chamber_name() -> void:
	var scene_name := GameManager.pending_scene_path.get_file().get_basename()
	if scene_name.begins_with("chamber_"):
		var number := scene_name.trim_prefix("chamber_").pad_zeros(2)
		chamber_number.text = "CHAMBER - " + number
	else:
		chamber_number.hide()
