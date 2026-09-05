extends CanvasLayer

const EMPTY_TEXTURE := preload("res://assets/ui/echo_resource_empty.tres")
const ACTIVE_TEXTURE := preload("res://assets/ui/echo_resource_active.tres")
const DIED_TEXTURE := preload("res://assets/ui/echo_resource_died.tres")

@onready var slots: Array[TextureRect] = [
	$MarginContainer/EchoSlots/Echo1,
	$MarginContainer/EchoSlots/Echo2,
	$MarginContainer/EchoSlots/Echo3
]


func _ready() -> void:
	EchoManager.resources_changed.connect(_update_slots)
	_update_slots(EchoManager.slot_states)


func _update_slots(states: Array) -> void:
	for index in slots.size():
		match states[index]:
			EchoManager.SLOT_ACTIVE:
				slots[index].texture = ACTIVE_TEXTURE
			EchoManager.SLOT_DIED:
				slots[index].texture = DIED_TEXTURE
			_:
				slots[index].texture = EMPTY_TEXTURE
