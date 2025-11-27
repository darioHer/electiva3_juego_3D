extends CharacterBody3D

signal squashed(score_value: int)

@export var min_speed: float = 10.0
@export var max_speed: float = 18.0

# Tipo de creep: normal, rápido rojo o bonus morado
@export_enum("normal", "fast_red", "bonus_purple") var mob_kind: String = "normal"


const COLOR_FAST   := Color(1, 0.2, 0.2)
const COLOR_BONUS  := Color(0.7, 0.2, 1.0) 

var score_value: int = 1


func _physics_process(_delta: float) -> void:
	move_and_slide()


func initialize(start_position: Vector3, player_position: Vector3) -> void:
	# Mirar hacia el jugador desde la posición de inicio
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 4.0, PI / 4.0))

	var random_speed := 0.0

	# Ajustar velocidad, color y puntaje según el tipo
	match mob_kind:
		"fast_red":
			random_speed = randf_range(max_speed * 1.5, max_speed * 2.0)
			score_value = 1
			_set_color(COLOR_FAST)
		"bonus_purple":
			random_speed = randf_range(min_speed, max_speed)
			score_value = 2
			_set_color(COLOR_BONUS)
		_:
			random_speed = randf_range(min_speed, max_speed)
			score_value = 1
	

	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

	if has_node("AnimationPlayer"):
		$AnimationPlayer.speed_scale = float(random_speed) / max(min_speed, 0.001)


func _set_color(color: Color) -> void:
	# Tintar todos los MeshInstance3D dentro del modelo del mob
	if not has_node("Pivot/Character"):
		return

	var character := $Pivot/Character
	_tint_meshes_recursive(character, color)


func _tint_meshes_recursive(node: Node, color: Color) -> void:
	if node is MeshInstance3D:
		var material := StandardMaterial3D.new()
		material.albedo_color = color

		var mesh_instance: MeshInstance3D = node
		var mesh: Mesh = mesh_instance.mesh
		if mesh != null:
			for i in range(mesh.get_surface_count()):
				mesh_instance.set_surface_override_material(i, material)

	for child in node.get_children():
		_tint_meshes_recursive(child, color)



func squash() -> void:
	emit_signal("squashed", score_value)
	queue_free()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
