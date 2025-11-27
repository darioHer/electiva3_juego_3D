extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar

func set_health(value: int):
	health_bar.value = value
