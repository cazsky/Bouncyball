extends UpgradeButton
class_name AscensionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func update_label(stat: float, multiplier: float, price: float) -> void:
	stat_label.text = str(snapped(stat, 0.01), " -> ", snapped(stat*multiplier, 0.01))
	price_label.text = str("Current Price: \n", snapped(price,0.01), " stars")
