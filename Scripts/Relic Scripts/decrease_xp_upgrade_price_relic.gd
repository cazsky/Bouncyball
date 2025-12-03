class_name Enlightenment
extends Relic

const BASE_COST: float = 30
const BASE_MULT: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cost = BASE_COST * cost_multiplier * pow(level,2)
	
	
func _init() -> void:
	relic_name = "Enlightenment"
	cost_multiplier = 1.5
	stat_multiplier = 1.05
	relic_effect = "xp_upgrade_discount" 
	scene_path = "res://Scenes/relics/decrease_xp_upgrade_price_relic.tscn"
	
func _upgrade() -> void:
	super()
	stat_multiplier = pow(BASE_MULT, self.level)
	cost = BASE_COST * cost_multiplier * pow(level,2)
	_activate_effect()
