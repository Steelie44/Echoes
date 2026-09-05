extends StaticBody2D
class_name PPlate

signal plate_pressed()
signal plate_released()

var bodies_on_plate: Array[Node2D] = []
@onready var off: Sprite2D = $off
@onready var d_zone: Area2D = $DetectionZone

func _ready():
	off.visible = true
	d_zone.body_entered.connect(_on_body_entered)
	d_zone.body_exited.connect(on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("Echo") or body.is_in_group("Pushable"):
		bodies_on_plate.append(body)
		
		if bodies_on_plate.size() == 1:
			off.visible = false
			plate_pressed.emit()

func on_body_exited(body: Node2D) -> void:
	bodies_on_plate.erase(body)
	if bodies_on_plate.is_empty():
		off.visible = true
		plate_released.emit()
