extends Node2D

@onready var speed_button: Button = $Control/TabContainer/Upgrades/GridContainer/Speed
@onready var friction_button: Button = $Control/TabContainer/Upgrades/GridContainer/Friction
@onready var power_button: Button = $Control/TabContainer/Upgrades/GridContainer/Power
@onready var bounciness_button: Button = $Control/TabContainer/Upgrades/GridContainer/Bounciness
@onready var score_button: Button = $Control/TabContainer/Upgrades/GridContainer/Score
@onready var popup: Button = $Control/Popup

const MENU_TIME: float = 0.15

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
	var tw := get_tree().create_tween()
	tw.set_parallel()
	# Moving the whole menu baord up
	tw.tween_property(self, "global_position", Vector2(0,300), MENU_TIME).set_trans(tw.TRANS_SINE).set_ease(tw.EASE_OUT)
	# Changing size of the pop up button
	tw.tween_property(popup, "size", Vector2(50,popup.size.y), MENU_TIME)
	tw.tween_property(popup, "position", Vector2(600,0), MENU_TIME).set_trans(tw.TRANS_SINE).set_ease(tw.EASE_OUT)
	await tw.finished

func _on_texture_button_pressed() -> void:
	if is_menu_open:
		close_menu()
	else:
		open_menu()
	is_menu_open = !is_menu_open
