extends UpgradeButton
class_name PerkButton

@onready var menu: Node2D = $"../../../../../../Menu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func update_perk(current_stack: int, max_stacks: int, price: float) -> void:
	stat_label.text = str(current_stack, " / ", max_stacks)
	price_label.text = str("Current Price: ", "\n", price, " gems")
	
#func activate_perk(current_stack: int, max_stacks: int, price: float, stat) -> void:
	#stat *= 2
	#print_debug(stat)
	#current_stack += 1
	#update_perk(current_stack, max_stacks, price)
	#await get_tree().create_timer(60).timeout
	#stat /= 2
	#current_stack -= 1
	#update_perk(current_stack, max_stacks, price)
