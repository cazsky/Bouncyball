extends Node2D

@onready var speed_button: Button = $Control/TabContainer/Upgrades/GridContainer/Speed
@onready var friction_button: Button = $Control/TabContainer/Upgrades/GridContainer/Friction
@onready var xp_button: Button = $Control/TabContainer/Upgrades/GridContainer/XPGain
@onready var bounciness_button: Button = $Control/TabContainer/Upgrades/GridContainer/Bounciness
@onready var score_button: Button = $Control/TabContainer/Upgrades/GridContainer/Score
@onready var popup: Button = $Control/Popup
@onready var arrow: Sprite2D = $Control/Arrow
@onready var ball: CharacterBody2D = $"../Ball"
@onready var speed_stat_label: Label = $"../Control/Stats/Speed"
@onready var velocity_stat_label: Label = $"../Control/Stats/Velocity"


# Base upgrade price
const BASE_SPEED_PRICE: int = 5
const BASE_FRICTION_PRICE: int = 10
const BASE_BOUNCINESS_PRICE: int = 30
const BASE_SCORE_PRICE: int = 50



# Consts UI
const MENU_TIME: float = 0.15

# Ball price upgrade multiplers
var speed_upgrade_price_multiplier: float = 1.2
var friction_upgrade_price_multiplier: float = 1.2
var bounciness_upgrade_price_multiplier: float = 1.3

# Ball stats upgrades multipliers
var speed_upgrade_stat_multiplier: float = 1.05
var friction_upgrade_stat_multiplier: float = 0.95
var bounciness_upgrade_stat_multiplier: float = 1.2

# Initialise vars
var is_menu_open: bool = false
var base_bounciness: float = 1.0
var bounciness: float = base_bounciness
var friction_price: int = BASE_FRICTION_PRICE
var bounciness_price: int = BASE_BOUNCINESS_PRICE
var score_price: int = BASE_SCORE_PRICE
var speed_price: int = BASE_SPEED_PRICE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug(ball)
	# Connect the ball bounce signal
	ball.bounce.connect(_on_ball_bounce)
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
	tw.tween_property(popup, "size", Vector2(1000,90), MENU_TIME)
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
	tw.tween_property(popup, "global_position", Vector2(get_viewport_rect().size.x - (get_viewport_rect().size.x / 19), (get_viewport_rect().size.y - 980)), MENU_TIME).set_trans(tw.TRANS_SINE).set_ease(tw.EASE_OUT)
	tw.tween_property(popup, "size", Vector2(32,32), MENU_TIME)
	await tw.finished
	

func _on_texture_button_pressed() -> void:
	if is_menu_open:
		close_menu()
	else:
		open_menu()
	is_menu_open = !is_menu_open

# Speed upgrade
func _on_speed_pressed() -> void:
	ball.current_speed *= speed_upgrade_stat_multiplier
	speed_stat_label.text = str("Speed: ", roundf(ball.current_speed))
	speed_price *= speed_upgrade_price_multiplier

# Friction upgrade
func _on_friction_pressed() -> void:
	ball.friction *= friction_upgrade_stat_multiplier
	friction_price *= friction_upgrade_price_multiplier

# Bounciness effect on collide
func _on_ball_bounce() -> void:
	ball.velocity *= bounciness

# Bounciness upgrade
func _on_bounciness_pressed() -> void:
	bounciness *= bounciness_upgrade_stat_multiplier
	bounciness_price *= bounciness_upgrade_price_multiplier
