extends Node2D
class_name ElevatorSmall


@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var anim_player: AnimationPlayer = $AnimatableBody2D/AnimationPlayer
@onready var collision: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
var is_down = true


func _ready() -> void:
	anim_player.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		anim_player.play("up")
	if Input.is_action_just_pressed("down"):
		anim_player.play("down")

func raise_elevator() -> void:
	if not is_down:
		return
	anim_player.play("up")
	audio_player.play()
	is_down = false

func lower_elevator() -> void:
	if is_down:
		return
	anim_player.play("down")
	audio_player.play()
	is_down = true
	await anim_player.animation_finished

func _on_animation_finished(animation_name: StringName) -> void:
	if animation_name == &"up" or animation_name == &"down":
		audio_player.stop()

		
