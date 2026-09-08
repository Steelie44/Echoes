extends Node2D

const MACHINA = preload("uid://3pe4kldcdk0s")
const CHAMBER_THREE := "res://scenes/chambers/chamber_3.tscn"
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var pressure_switch: PPlate = %PressureSwitch
@onready var portal: LevelPortal = %Portal
@onready var bridge_2: Bridge_2 = $Props/Bridge_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EchoManager.ensure_capacity_for_chamber(2)
	audio_player.stream = MACHINA
	EchoManager.play_level_music(audio_player)

	# Chamber 2's portal is controlled only by its pressure plate.
	bridge_2.portal = null
	portal.next_level_path = CHAMBER_THREE
	portal.set_active(false)
	pressure_switch.plate_pressed.connect(_on_pressure_switch_pressed)
	pressure_switch.plate_released.connect(_on_pressure_switch_released)


func _on_pressure_switch_pressed() -> void:
	portal.set_active(true)


func _on_pressure_switch_released() -> void:
	portal.set_active(false)


func _process(delta: float) -> void:
	pass
