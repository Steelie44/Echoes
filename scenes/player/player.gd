extends CharacterBody2D

@export var speed: float = 200.0
@export var run_speed: float = 350.0
@export var jump_velocity: float = -400.0
@export var push_force: float = 100.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_direction: String = "r"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("left", "right")
	var is_running = Input.is_action_pressed("run")
	var current_speed = run_speed if is_running else speed

	if direction != 0:
		velocity.x = direction * current_speed
		facing_direction = "l" if direction < 0 else "r"
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	update_animations(direction, is_running)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		if body.is_in_group("Pushable"):
			var push_direction = -collision.get_normal()
			body.apply_central_force(push_direction * push_force)

func update_animations(direction: float, is_running: bool) -> void:
	if not is_on_floor():
		animated_sprite.play("jump_" + facing_direction)
	elif direction != 0:
		if is_running:
			animated_sprite.play("run_" + facing_direction)
		else:
			animated_sprite.play("walk_" + facing_direction)
	else:
		animated_sprite.play("idle")
		animated_sprite.play("walk_" + facing_direction)
		animated_sprite.pause()
		animated_sprite.frame = 0

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		trigger_interaction()

func trigger_interaction() -> void:
	print("Interact action triggered!")
