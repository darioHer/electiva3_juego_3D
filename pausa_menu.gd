extends CanvasLayer

@onready var panel: Panel = $Panel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.visible = false


func show_menu() -> void:
	panel.visible = true
	get_tree().paused = true


func hide_menu() -> void:
	panel.visible = false
	get_tree().paused = false


func _on_ResumeButton_pressed() -> void:
	hide_menu()


func _on_RestartButton_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
