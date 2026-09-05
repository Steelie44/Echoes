extends RigidBody2D
class_name Bollard


@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var pplate: PPlate
var is_up = true

func _ready():
	pplate.plate_pressed.connect(_on_plate_pressed)
	pplate.plate_released.connect(_on_plate_released)

func _physics_process(delta: float) -> void:
	pass
	
func lower_bollard() -> void:
	if is_up == true:
		anim.play("down")
		is_up = false
	
func raise_bollard() -> void:
	if is_up == false:
		anim.play("up")
		is_up = true
	
func _on_plate_pressed() -> void:
	lower_bollard()
	
func _on_plate_released() -> void:
	raise_bollard()
	
	
