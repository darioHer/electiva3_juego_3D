extends CharacterBody3D

signal hit

# How fast the player moves in meters per second.
@export var speed: float = 14.0
# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse: float = 20.0
# Vertical impulse applied to the character upon bouncing over a mob in meters per second.
@export var bounce_impulse: float = 16.0
# The downward acceleration when in the air, in meters per second per second.
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
		# Girar el personaje hacia la dirección de movimiento
		pivot.look_at(global_position + direction, Vector3.UP)
		# Acelerar animación (por ejemplo, animación de correr)
		anim.speed_scale = 4.0
		# Si tienes animaciones llamadas "Run" o "Walk", puedes hacer:
		# anim.play("Run")
	else:
		# Velocidad normal de animación cuando está quieto
		anim.speed_scale = 1.0
		# anim.play("Idle")  # si tienes esa animación

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

	# Comprobar colisiones (para pisar mobs)
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider and collider.is_in_group("mob"):
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				collider.squash()
				velocity.y = bounce_impulse

	# Hacer que el personaje se “agache/estire” al saltar/caer
	pivot.rotation.x = PI / 6.0 * velocity.y / jump_impulse


func die() -> void:
	emit_signal("hit")
	queue_free()


func _on_MobDetector_body_entered(_body: Node) -> void:
	die()
