extends CanvasLayer

const EMPTY_TEXTURE := preload("res://assets/ui/echo_resource_empty.tres")
const ACTIVE_TEXTURE := preload("res://assets/ui/echo_resource_active.tres")
const DIED_TEXTURE := preload("res://assets/ui/echo_resource_died.tres")

@onready var slot_container: HBoxContainer = $ControlsOverlay/EchoSlots

var slots: Array[TextureRect] = []


func _ready() -> void:
	for child in slot_container.get_children():
		if child is TextureRect:
			slots.append(child)
	EchoManager.resources_changed.connect(_update_slots)
	_update_slots(EchoManager.slot_states)


func _update_slots(states: Array) -> void:
	_ensure_slot_count(states.size())
	for index in states.size():
		match states[index]:
			EchoManager.SLOT_ACTIVE:
				slots[index].texture = ACTIVE_TEXTURE
			EchoManager.SLOT_DIED:
				slots[index].texture = DIED_TEXTURE
			_:
				slots[index].texture = EMPTY_TEXTURE


func _ensure_slot_count(count: int) -> void:
	if slots.is_empty():
		return

	while slots.size() < count:
		var slot := slots[0].duplicate() as TextureRect
		slot.name = "Echo%d" % (slots.size() + 1)
		slot_container.add_child(slot)
		slots.append(slot)

	while slots.size() > count:
		var slot: TextureRect = slots.pop_back()
		slot.queue_free()
