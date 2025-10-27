class_name Spring_Loaded
extends Relic

const BASE_COST: float = 30
const BASE_MULT: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cost = BASE_COST * cost_multiplier * fmod(pow(level,2), 10)
	
	
func _init() -> void:
	relic_name = "spring_loaded"
	cost_multiplier = 1.5
	stat_multiplier = 1.05
	relic_effect = "bounce_upgrade_discount" #?
	scene_path = "res://Scripts/Relic Scripts/decrease_bounce_upgrade_price_relic.gd"
	relic_id = 6
	
func _upgrade() -> void:
	super()
	stat_multiplier = pow(BASE_MULT, self.level)
	_activate_effect()
