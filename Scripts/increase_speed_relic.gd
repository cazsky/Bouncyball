extends Relic

const BASE_COST: float = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	relic_name = "wings_of_hermes"
	cost_multiplier = 1.5
	cost = BASE_COST * cost_multiplier * fmod(pow(level,2), 10)
	stat_multiplier = 1.05
	ball.current_speed *= stat_multiplier



func _on_child_entered_tree(node: Node) -> void:
	ball.current_speed *= stat_multiplier
