extends Node2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var elevator_switch: Switch_3 = %switch_3
@onready var elevator: ElevatorSmall = %ElevatorSmall
@onready var lasers: Array[Node2D] = [
	$Props/Lasers/LaserLeft_1,
	$Props/Lasers/LaserLeft_2,
	$Props/Lasers/LaserRight_1,
	$Props/Lasers/LaserRight_2
]
func _ready() -> void:
	EchoManager.play_level_music(audio_player)
	EchoManager.ensure_capacity_for_chamber(3)
	elevator_switch.switched_on.connect(elevator.raise_elevator)
	elevator_switch.switched_off.connect(elevator.lower_elevator)

	if elevator_switch.is_on:
		elevator.raise_elevator()

func disable_laser(laser: Node2D) -> void:
	var sprite := laser.get_node("AnimatedSprite2D") as AnimatedSprite2D
	var hurt_area := sprite.get_node("hurt") as Area2D
	sprite.pause()
	hurt_area.set_deferred("monitoring", false)

func enable_laser(laser: Node2D) -> void:
	var sprite := laser.get_node("AnimatedSprite2D") as AnimatedSprite2D
	var hurt_area := sprite.get_node("hurt") as Area2D
	sprite.play("laser_on")
	hurt_area.set_deferred("monitoring", true)

func enable_all_lasers() -> void:
	for laser in lasers:
		enable_laser(laser)
