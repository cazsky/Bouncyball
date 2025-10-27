class_name Shiny_Orb
extends Relic

const BASE_COST: float = 30
const BASE_MULT: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cost = BASE_COST * cost_multiplier * fmod(pow(level,2), 10)
	
	
func _init() -> void:
	relic_name = "shiny_orb"
	cost_multiplier = 1.5
	stat_multiplier = 1.05
	relic_effect = "gem_gain_multiplier"
	scene_path = "res://Scenes/relics/increase_bounce_relic.tscn"
	relic_id = 5


func _activate_effect() -> void:
	menu = await wait_for_node("../../../../../../Menu")
	menu.game.set(relic_effect, menu.game.get(relic_effect) * stat_multiplier)
	
func _upgrade() -> void:
	super()
	stat_multiplier = pow(BASE_MULT, self.level)
	_activate_effect()
