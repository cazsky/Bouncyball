extends Button
class_name UpgradeButton


@onready var stat_label: Label = $StatLabel
@onready var label: Label = $Label
@onready var price_label: Label = $PriceLabel

## Text that will show on right of button
@export_multiline var label_text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = label_text

func update_label(stat: float, multiplier: float, price: float) -> void:
		stat_label.text = str(snapped(stat, 0.01), " -> ", snapped(stat*multiplier, 0.01))
		price_label.text = str("Current Price: \n", snapped(price,0.01), " score")
