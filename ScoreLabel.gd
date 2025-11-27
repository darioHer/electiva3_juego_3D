extends Label

var score: int = 0

func reset_score() -> void:
	score = 0
	text = "Score: 0"

func add_points(value: int) -> void:
	score += value
	text = "Score: %s" % score
