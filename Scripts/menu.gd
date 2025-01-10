extends Node2D

@onready var speed_button: Button = $Control/TabContainer/Upgrades/GridContainer/Speed
@onready var friction_button: Button = $Control/TabContainer/Upgrades/GridContainer/Friction
@onready var power_button: Button = $Control/TabContainer/Upgrades/GridContainer/Power
@onready var bounciness_button: Button = $Control/TabContainer/Upgrades/GridContainer/Bounciness
@onready var score_button: Button = $Control/TabContainer/Upgrades/GridContainer/Score

# Ball price upgrade multiplers
var speed_upgrade_price_multiplier: float = 1.2
var friction_upgrade_price_multiplier: float = 1.2
var is_menu_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func close_menu() -> void:
	pass
	
func open_menu() -> void:
	pass



func _on_texture_button_pressed() -> void:
	print_debug("???")
