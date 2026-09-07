extends Node2D
class_name LevelPortal

signal level_completed

const PORTAL_SOUND: AudioStream = preload("res://assets/audio/portal.wav")
const TITLE_SCREEN := "res://scenes/ui/title_screen.tscn"
@export_file("*.tscn") var next_level_path := TITLE_SCREEN
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var portal_area: Area2D = $portal_area

var is_active := false
var level_is_ending := false


func _ready() -> void:
	audio_player.stream = PORTAL_SOUND
	add_to_group("Interactable")
	animated_sprite.play("portal_off")


func set_active(active: bool) -> void:
	if is_active == active:
		return

	is_active = active
	animated_sprite.play("portal_on" if is_active else "portal_off")
	audio_player.play()


func interact(body: Node2D) -> void:
	if not is_active or level_is_ending or not body.is_in_group("Player"):
		return

	level_is_ending = true
	level_completed.emit()
	EchoManager.complete_level()
	GameManager.load_scene_with_hint(next_level_path)
