class_name WingsOfHermes
extends Relic

const BASE_COST: float = 10
const BASE_MULT: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func _init() -> void:
	relic_name = "wings_of_hermes"
	cost_multiplier = 1.5
	cost = BASE_COST * cost_multiplier * fmod(pow(level,2), 10)
	stat_multiplier = 1.05
	relic_effect = "speed_mult"
	scene_path = "res://Scenes/relics/increase_speed_relic.tscn"

	
func _activate_effect() -> void:
	# Without this await ball is null in this function????
	# This is causing issues i think :3
	#await self.ready
	menu = await wait_for_node("../../../../../../Menu")
	menu.speed_mult = menu.get(relic_effect) * stat_multiplier
	print_debug("Effect speed mult: ", menu.get(relic_effect))
	
func _upgrade() -> void:
	super()
	stat_multiplier = pow(BASE_MULT, self.level)
	_activate_effect()
