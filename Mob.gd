extends CharacterBody3D

signal squashed

@export var min_speed: float = 10.0
@export var max_speed: float = 18.0

func _physics_process(_delta: float) -> void:
	move_and_slide()

func initialize(start_position: Vector3, player_position: Vector3) -> void:
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4.0, PI / 4.0))

	var random_speed := randf_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

	$AnimationPlayer.speed_scale = float(random_speed) / float(min_speed)

func squash() -> void:
	emit_signal("squashed")
	queue_free()

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
