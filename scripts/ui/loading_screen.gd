extends Control

@export var display_time := 2.5
@onready var hint_label: Label = $AspectRatioContainer/Label


func _ready() -> void:
	var hints := Hints.new()
	if not hints.hint_list.is_empty():
		hint_label.text = "Hint: " + hints.hint_list.pick_random()
	hints.queue_free()

	await get_tree().create_timer(display_time).timeout
	GameManager.finish_loading()
