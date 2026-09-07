extends Control

@onready var button_sfx: AudioStreamPlayer = $ButtonSFX
@onready var menu_music: AudioStreamPlayer = $MenuMusic

@onready var new_game_button: Button = $VBoxContainer/NewGame
@onready var load_game_button: Button = $VBoxContainer/LoadGame
@onready var options_button: Button = $VBoxContainer/Options
@onready var quit_button: Button = $VBoxContainer/Quit

const LEVEL_ONE := "res://scenes/chambers/test_chamber.tscn"
const HOVER_SOUND := preload("res://ui/titlescreen/menu_button_hover.wav")
const CLICK_SOUND := preload("res://ui/titlescreen/menu_button_click.wav")
const MAIN_MENU_MUSIC := preload("res://ui/titlescreen/MMM.wav")


func _ready() -> void:
	menu_music.stream = MAIN_MENU_MUSIC
	menu_music.play()

	new_game_button.mouse_entered.connect(play_hover_sound)
	load_game_button.mouse_entered.connect(play_hover_sound)
	options_button.mouse_entered.connect(play_hover_sound)
	quit_button.mouse_entered.connect(play_hover_sound)

	new_game_button.pressed.connect(_on_new_game_pressed)
	load_game_button.pressed.connect(play_click_sound)
	options_button.pressed.connect(play_click_sound)
	quit_button.pressed.connect(_on_quit_pressed)
	new_game_button.grab_focus()


func play_hover_sound() -> void:
	button_sfx.stream = HOVER_SOUND
	button_sfx.play()


func play_click_sound() -> void:
	button_sfx.stream = CLICK_SOUND
	button_sfx.play()


func _on_new_game_pressed() -> void:
	play_click_sound()
	new_game_button.disabled = true
	EchoManager.reset_progress()
	await get_tree().create_timer(0.15).timeout
	GameManager.load_scene_with_hint(LEVEL_ONE)


func _on_quit_pressed() -> void:
	play_click_sound()
	quit_button.disabled = true
	await get_tree().create_timer(0.15).timeout
	get_tree().quit()
