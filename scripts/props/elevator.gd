extends Node2D
class_name Elevator


@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@export var switch_3: Switch_3
var is_down = true


func _ready() -> void:
	anim_player.animation_finished.connect(_on_animation_finished)
	if switch_3:
		switch_3.switched_on.connect(_on_switch_3_on)
		switch_3.switched_off.connect(_on_switch_3_off)

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

func _on_animation_finished(animation_name: String) -> void:
	if animation_name == &"up" or animation_name == &"down":
		audio_player.stop()

func _on_switch_3_on() -> void:
	raise_elevator()
	
func _on_switch_3_off() -> void:
	lower_elevator()
		
