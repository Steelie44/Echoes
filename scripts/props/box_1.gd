extends RigidBody2D

@export var push_sound_grace_time := 0.10
@onready var slide_audio: AudioStreamPlayer = $SlideAudio

var push_sound_time_left := 0.0


func notify_pushed() -> void:
	push_sound_time_left = push_sound_grace_time
	if not slide_audio.playing:
		slide_audio.play()


func _physics_process(delta: float) -> void:
	push_sound_time_left = maxf(push_sound_time_left - delta, 0.0)
	if push_sound_time_left == 0.0 and slide_audio.playing:
		slide_audio.stop()
