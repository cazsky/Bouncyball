extends Button
class_name RelicUpgradeButton

@onready var label: Label = $"../Label"
@onready var price_label: Label = $"../PriceLabel"
@onready var relic = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func update_label(price: float) -> void:
	price_label.text = str("Current Price: \n", snapped(price,0.01), " score")
	relic.update_label()
