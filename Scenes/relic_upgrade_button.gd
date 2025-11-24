extends Button
class_name RelicUpgradeButton

@onready var label: Label = $"../Label"
@onready var price_label: Label = $"../PriceLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = label_text

func update_label(stat: float, multiplier: float, price: float) -> void:
	stat_label.text = str(snapped(stat, 0.01), " -> ", snapped(stat*multiplier, 0.01))
	price_label.text = str("Current Price: \n", snapped(price,0.01), " score")
