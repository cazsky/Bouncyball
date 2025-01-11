extends Node2D

@onready var speed_button: Button = $Control/TabContainer/Upgrades/GridContainer/Speed
@onready var friction_button: Button = $Control/TabContainer/Upgrades/GridContainer/Friction
@onready var power_button: Button = $Control/TabContainer/Upgrades/GridContainer/Power
@onready var bounciness_button: Button = $Control/TabContainer/Upgrades/GridContainer/Bounciness
@onready var score_button: Button = $Control/TabContainer/Upgrades/GridContainer/Score
@onready var popup: Button = $Control/Popup
@onready var arrow: Sprite2D = $Control/Arrow

const MENU_TIME: float = 0.15

# Ball price upgrade multiplers
var speed_upgrade_price_multiplier: float = 1.2
var friction_upgrade_price_multiplier: float = 1.2
var is_menu_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func close_menu() -> void:
	arrow.flip_v = false
	var tw := get_tree().create_tween()
	tw.set_parallel()
	# Moving the whole menu board down
	tw.tween_property(self, "global_position", Vector2(0, 1180), MENU_TIME)
	# Changing size of the pop up button
	tw.tween_property(popup, "size", Vector2(1000,popup.size.y), MENU_TIME)
	tw.tween_property(popup, "global_position", Vector2(0,1180), MENU_TIME).set_trans(tw.TRANS_SINE).set_ease(tw.EASE_OUT)
	await tw.finished
		
func open_menu() -> void:
	arrow.flip_v = true
	var tw := get_tree().create_tween()
	tw.set_parallel()
	# Moving the whole menu board up
	tw.tween_property(self, "global_position", Vector2(0,300), MENU_TIME).set_trans(tw.TRANS_SINE).set_ease(tw.EASE_OUT)
	# Changing size of the pop up button
	# This is crazy spaghetti
	# get_viewport_rect().size.x returns a fixed 720 as compared to get_viewport()
	tw.tween_property(popup, "global_position", Vector2(get_viewport_rect().size.x - (get_viewport_rect().size.x / 11), (get_viewport_rect().size.y - 980)), MENU_TIME).set_trans(tw.TRANS_SINE).set_ease(tw.EASE_OUT)
	tw.tween_property(popup, "size", Vector2(64,popup.size.y), MENU_TIME)
	await tw.finished
	

func _on_texture_button_pressed() -> void:
	if is_menu_open:
		close_menu()
	else:
		open_menu()
	is_menu_open = !is_menu_open
