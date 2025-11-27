extends Node

@export var mob_scene: PackedScene

@onready var hud          = $HUD                   # HUD con la barra de vida
@onready var player       = $Player
@onready var mob_timer: Timer = $MobTimer
@onready var pause_menu   = $PauseMenu            # nodo PauseMenu (CanvasLayer)
@onready var score_label  = $UserInterface/ScoreLabel
@onready var spawn_path   = $SpawnPath/SpawnLocation


# --- Lógica de "oleadas" para el creep morado ---
const MOBS_PER_WAVE := 10
var mobs_spawned_in_wave: int = 0
var purple_spawn_slot: int = 1


func _ready() -> void:
	randomize()
	process_mode = Node.PROCESS_MODE_ALWAYS

	$UserInterface/Retry.hide()
	update_lives(player.current_lives)
	_start_new_wave()


func _unhandled_input(event: InputEvent) -> void:
	# Pausa con ESC (ui_cancel)
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			pause_menu.hide_menu()
		else:
			pause_menu.show_menu()


func _start_new_wave() -> void:
	mobs_spawned_in_wave = 0
	# Elegimos en qué número de mob de la oleada saldrá el morado (1..MOBS_PER_WAVE)
	purple_spawn_slot = randi_range(1, MOBS_PER_WAVE)


func _spawn_mob() -> void:
	# Control de oleadas (cada N mobs se reinicia)
	if mobs_spawned_in_wave >= MOBS_PER_WAVE:
		_start_new_wave()

	mobs_spawned_in_wave += 1

	var mob: CharacterBody3D = mob_scene.instantiate()

	# Decidir tipo de mob (ya NO usamos has_variable)
	if mobs_spawned_in_wave == purple_spawn_slot:
		# Creep morado → sale sólo una vez por “oleada”
		mob.mob_kind = "bonus_purple"
	else:
		# Entre normal y rojo rápido
		var r := randf()
		if r < 0.3:
			mob.mob_kind = "fast_red"   # 30% de probabilidad
		else:
			mob.mob_kind = "normal"

	# Posición de spawn a lo largo del Path3D
	spawn_path.progress_ratio = randf()
	var spawn_position: Vector3 = spawn_path.global_position
	var player_position: Vector3 = player.global_position

	mob.initialize(spawn_position, player_position)
	add_child(mob)

	# Conectar señal para sumar score al aplastar mobs
	if mob.has_signal("squashed"):
		mob.connect("squashed", Callable(score_label, "add_points"))



func _on_MobTimer_timeout() -> void:
	_spawn_mob()


func update_lives(value: int) -> void:
	hud.set_health(value)


func _on_player_hit() -> void:
	# Actualizar barra de vida
	update_lives(player.current_lives)

	# Si muere → detener mobs + mostrar Retry
	if player.current_lives <= 0:
		mob_timer.stop()
		get_tree().paused = true
		$UserInterface/Retry.show()


func _on_resume_button_pressed() -> void:
	pause_menu.hide_menu()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
