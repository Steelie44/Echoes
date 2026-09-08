extends CanvasLayer

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

const TUTORIAL_PAGES: Array[String] = [
	"Intro",
	"T1",
	"T2",
	"T3",
	"T4",
	"T5",
	"T6",
	"DeathWarning"
]
const MESSAGE_FROM_CENTER := Vector2(-250, -80)
const BUTTON_FROM_CENTER := Vector2(46, 150)

@onready var background: Sprite2D = $Sprite2D
@onready var message_label: RichTextLabel = $RichTextLabel
@onready var next_button: Button = $Button
@export var dialog_offset: Vector2 = Vector2(-100, -75)

var messages: Dictionary = {}
var page_index := 0
var is_showing_dialog := false


func _ready() -> void:
	_center_background()
	get_viewport().size_changed.connect(_center_background)

	if GameManager.chamber_one_intro_seen:
		queue_free()
		return

	GameManager.chamber_one_intro_seen = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	var dialog_data := Dialog.new()
	messages = dialog_data.dialog.duplicate()
	dialog_data.queue_free()

	next_button.pressed.connect(_show_next_page)
	is_showing_dialog = true
	get_tree().paused = true
	_show_page()
	next_button.grab_focus()

func _center_background() -> void:
	var center := get_viewport().get_visible_rect().size * 0.5
	background.position = center + dialog_offset
	message_label.position = center + MESSAGE_FROM_CENTER + dialog_offset
	next_button.position = center + BUTTON_FROM_CENTER + dialog_offset
	

func _show_page() -> void:
	message_label.text = messages.get(TUTORIAL_PAGES[page_index], "")
	next_button.text = "START" if page_index == TUTORIAL_PAGES.size() - 1 else "NEXT"

func _show_next_page() -> void:
	page_index += 1
	if page_index >= TUTORIAL_PAGES.size():
		_close_dialog()
		return
	_show_page()

func _close_dialog() -> void:
	is_showing_dialog = false
	get_tree().paused = false
	queue_free()

func _exit_tree() -> void:
	if is_showing_dialog:
		get_tree().paused = false

func _on_button_pressed() -> void:
	audio_player.play()
