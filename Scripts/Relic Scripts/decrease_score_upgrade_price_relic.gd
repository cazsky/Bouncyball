class_name Shiny_Gem
extends Relic

const BASE_COST: float = 30
const BASE_MULT: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cost = BASE_COST * cost_multiplier * fmod(pow(level,2), 10)
	
	
func _init() -> void:
	relic_name = "shiny_gem"
	cost_multiplier = 1.5
	stat_multiplier = 1.05
	relic_effect = "xp_upgrade_discount" 
	scene_path = "res://Scenes/relics/decrease_xp_upgrade_price_relic.tscn"
	
func _upgrade() -> void:
	super()
	stat_multiplier = pow(BASE_MULT, self.level)
	_activate_effect()
