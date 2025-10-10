class_name CrystalBall
extends Relic

const BASE_COST: float = 20
const BASE_MULT: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cost = BASE_COST * cost_multiplier * fmod(pow(level,2), 10)
	
	
func _init() -> void:
	relic_name = "crstal_ball"
	cost_multiplier = 1.5
	stat_multiplier = 1.05
	relic_effect = "speed_mult"
	scene_path = "res://Scenes/relics/increase_xp_relic.tscn"
	relic_id = 4

func _upgrade() -> void:
	super()
	stat_multiplier = pow(BASE_MULT, self.level)
	_activate_effect()
