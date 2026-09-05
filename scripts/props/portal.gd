extends Node2D
class_name LevelPortal

signal level_completed

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var portal_area: Area2D = $portal_area

var is_active := false


func _ready() -> void:
	portal_area.body_entered.connect(_on_body_entered)
	set_active(false)


func set_active(active: bool) -> void:
	is_active = active
	$AnimatedSprite2D.play("portal_on" if is_active else "portal_off")


func _on_body_entered(body: Node2D) -> void:
	if is_active and body.is_in_group("Player"):
		level_completed.emit()
		print("Level complete!")
