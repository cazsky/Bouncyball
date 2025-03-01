extends Relic

const BASE_COST: float = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	relic_name = "wings_of_hermes"
	cost_multiplier = 1.5
	ball.current_speed *= stat_multiplier
	cost = BASE_COST * cost_multiplier * level
