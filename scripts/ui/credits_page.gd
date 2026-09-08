extends Node2D

@onready var button: Button = $Button
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_back_pressed() -> void:
	audio_player.play()
	GameManager.load_scene_with_hint("res://scenes/ui/credit_page.tscn")
	get_tree().change_scene_to_file("res://scenes/ui/title_screen.tscn")
