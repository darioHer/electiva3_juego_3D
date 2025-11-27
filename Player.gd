extends CharacterBody3D

signal hit   # Se emite cada vez que el jugador pierde una vida

# VIDAS DEL JUGADOR
@export var max_lives: int = 3
var current_lives: int = 3

# Movimiento
@export var speed: float = 14.0
@export var jump_impulse: float = 20.0
@export var bounce_impulse: float = 16.0
@export var fall_acceleration: float = 75.0

@onready var pivot: Node3D = $Pivot
@onready var anim: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	var direction := Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		pivot.look_at(global_position + direction, Vector3.UP)
		anim.speed_scale = 4.0
	else:
		anim.speed_scale = 1.0

	# Movimiento horizontal
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Salto
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_impulse

	# Gravedad
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta

	# Mover el cuerpo
	move_and_slide()

	# Aplastar mobs
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider and collider.is_in_group("mob"):
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				collider.squash()
				velocity.y = bounce_impulse

	# “Arco” del salto
	pivot.rotation.x = PI / 6.0 * velocity.y / jump_impulse


func die() -> void:
	# ↓↓↓ aquí se resta la vida ↓↓↓
	current_lives -= 1
	emit_signal("hit")  # avisamos al Main que perdió una vida

	if current_lives <= 0:
		queue_free()


func _on_MobDetector_body_entered(_body: Node) -> void:
	# cada vez que un mob entra en el detector, el jugador recibe daño
	die()
