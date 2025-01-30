extends Button
class_name UpgradeButton


@onready var stat_label: Label = $StatLabel
@onready var label: Label = $Label

## Text that will show on right of button
@export_multiline var label_text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = label_text
	
func update_stat(stat: float, multiplier: float) -> void:
	stat_label.text = str(snapped(stat, 0.01), " -> ", snapped(stat*multiplier, 0.01))
#
#func update_price(price: float) -> void:
	#label.text = str("Current Price: \n", snapped(price,0.01))
