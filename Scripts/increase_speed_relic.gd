class_name WingsOfHermes
extends Relic

const BASE_COST: float = 10
const BASE_MULT: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#super()
	pass
	
	
func _init() -> void:
	relic_name = "wings_of_hermes"
	cost_multiplier = 1.5
	cost = BASE_COST * cost_multiplier * fmod(pow(level,2), 10)
	stat_multiplier = 1.05

	
func _activate_effect() -> void:
	# Without this await ball is null in this function????
	await self.ready
	menu.speed_mult *= stat_multiplier
	
func _upgrade() -> void:
	super()
	stat_multiplier = pow(BASE_MULT, self.level)
