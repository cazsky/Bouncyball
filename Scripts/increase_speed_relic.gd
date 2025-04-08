extends Relic

const BASE_COST: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	
	
func _init() -> void:
	relic_name = "wings_of_hermes"
	cost_multiplier = 1.5
	cost = BASE_COST * cost_multiplier * fmod(pow(level,2), 10)
	stat_multiplier = 1.05

	
func activate_effect() -> void:
	# Without this await ball is null in this function????
	# And I cant put this in the parent??
	await self.ready
	menu.speed_mult *= stat_multiplier
