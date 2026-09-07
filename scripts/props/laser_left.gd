extends Node2D
class_name LaserLeft

@export var damage := 100.0
@onready var hurt: Area2D = $AnimatedSprite2D/hurt
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	hurt.body_entered.connect(_on_hurt_body_entered)
	anim.play("laser_on")

func _on_hurt_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and body.has_method("take_damage"):
		body.take_damage(damage)
