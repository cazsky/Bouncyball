extends Node2D

@onready var speed_button: Button = $Control/TabContainer/Upgrades/GridContainer/Speed
@onready var velocity_button: Button = $Control/TabContainer/Upgrades/GridContainer/Velocity
@onready var xp_button: Button = $Control/TabContainer/Upgrades/GridContainer/XPGain
@onready var bounciness_button: Button = $Control/TabContainer/Upgrades/GridContainer/Bounciness
@onready var score_button: Button = $Control/TabContainer/Upgrades/GridContainer/Score

@onready var speed_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/SpeedPrice
@onready var velocity_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/VelocityPrice
@onready var xp_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/XPPrice
@onready var bounciness_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/BouncinessPrice
@onready var score_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/ScorePrice

@onready var popup: Button = $Control/Popup
@onready var arrow: Sprite2D = $Control/Arrow
@onready var ball: CharacterBody2D = $"../Ball"
@onready var speed_stat_label: Label = $"../Control/Stats/Speed"
@onready var velocity_stat_label: Label = $"../Control/Stats/Velocity"
@onready var game: Node2D = $"../../Game"

# Base upgrade price
const BASE_SPEED_PRICE: int = 5
const BASE_VELOCITY_PRICE: int = 10
const BASE_XP_PRICE: int = 15
const BASE_BOUNCINESS_PRICE: int = 30
const BASE_SCORE_PRICE: int = 50


# Consts UI
const MENU_TIME: float = 0.15

# Ball price upgrade multiplers
var speed_upgrade_price_multiplier: float = 1.2
var velocity_upgrade_price_multiplier: float = 1.2
var bounciness_upgrade_price_multiplier: float = 1.3

# Ball stats upgrades multipliers
var speed_upgrade_stat_multiplier: float = 1.05
var velocity_upgrade_stat_multiplier: float = 1.05
var bounciness_upgrade_stat_multiplier: float = 1.2

# Initialise vars
var is_menu_open: bool = false
var base_bounciness: float = 1.0
var bounciness: float = base_bounciness
var velocity_price: int = BASE_VELOCITY_PRICE
var speed_price: int = BASE_SPEED_PRICE
var xp_price: int = BASE_XP_PRICE
var bounciness_price: int = BASE_BOUNCINESS_PRICE
var score_price: int = BASE_SCORE_PRICE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the ball bounce signal
	ball.bounce.connect(_on_ball_bounce)
	update_price(speed_price_label,speed_price)
	update_price(velocity_price_label, velocity_price)
	update_price(xp_price_label, xp_price)
	update_price(bounciness_price_label, bounciness_price)
	update_price(score_price_label, score_price)
	
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
	if game.score >= speed_price:
		game.score -= speed_price
		ball.current_speed *= speed_upgrade_stat_multiplier
		ball.velocity *= speed_upgrade_stat_multiplier
		speed_stat_label.text = str("Speed: ", roundf(ball.current_speed))
		speed_price *= speed_upgrade_price_multiplier
		ball.max_velocity = ball.current_speed
		update_price(speed_price_label, speed_price)


# Bounciness effect on collide
func _on_ball_bounce() -> void:
	ball.velocity *= bounciness

# Bounciness upgrade
func _on_bounciness_pressed() -> void:
	bounciness *= bounciness_upgrade_stat_multiplier
	bounciness_price *= bounciness_upgrade_price_multiplier

# Function to update price values on labels easier
func update_price(label: Label, price: int) -> void:
	label.text = str("Current Price: \n", price)

# Velocity upgrade
func _on_velocity_pressed() -> void:
	ball.max_velocity *= velocity_upgrade_stat_multiplier
	velocity_price *= velocity_upgrade_price_multiplier
