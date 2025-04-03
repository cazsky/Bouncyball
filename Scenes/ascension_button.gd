extends UpgradeButton
class_name AscensionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func update_price(price: float) -> void:
	price_label.text = str("Current Price: \n", snapped(price,0.01), " stars")
