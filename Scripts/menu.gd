extends Node2D

# Buttons
#@onready var speed_button: Button = $Control/TabContainer/Upgrades/GridContainer/Speed
@onready var speed_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/Speed
@onready var friction_button: Button = $Control/TabContainer/Upgrades/GridContainer/Friction
@onready var xp_button: Button = $Control/TabContainer/Upgrades/GridContainer/XPGain
@onready var bounciness_button: Button = $Control/TabContainer/Upgrades/GridContainer/Bounciness
@onready var score_button: Button = $Control/TabContainer/Upgrades/GridContainer/Score

# Price Labels
@onready var speed_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/SpeedPrice
@onready var friction_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/FrictionPrice
@onready var xp_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/XPPrice
@onready var bounciness_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/BouncinessPrice
@onready var score_price_label: Label = $Control/TabContainer/Upgrades/VBoxContainer/ScorePrice

# Stat Labels
#@onready var speed_stat_label: Label = $Control/TabContainer/Upgrades/GridContainer/Speed/StatLabel
@onready var friction_stat_label: Label = $Control/TabContainer/Upgrades/GridContainer/Friction/StatLabel
@onready var xp_stat_label: Label = $Control/TabContainer/Upgrades/GridContainer/XPGain/StatLabel
@onready var bounciness_stat_label: Label = $Control/TabContainer/Upgrades/GridContainer/Bounciness/StatLabel
@onready var score_stat_label: Label = $Control/TabContainer/Upgrades/GridContainer/Score/StatLabel

@onready var popup: Button = $Control/Popup
@onready var arrow: Sprite2D = $Control/Arrow
@onready var ball: CharacterBody2D = $"../Ball"
@onready var game: Node2D = $"../../Game"

# Base upgrade price
const BASE_SPEED_PRICE: int = 10
const BASE_FRICTION_PRICE: int = 10
const BASE_XP_PRICE: int = 20
const BASE_BOUNCINESS_PRICE: int = 30
const BASE_SCORE_PRICE: int = 50


# Consts UI
const MENU_TIME: float = 0.15

# Ball price upgrade multiplers
var speed_upgrade_price_multiplier: float = 1.2
var friction_upgrade_price_multiplier: float = 1.2
var bounciness_upgrade_price_multiplier: float = 1.3
var xp_upgrade_price_multiplier: float = 1.3
var score_upgrade_price_multiplier: float = 1.3

# Ball stats upgrades multipliers
var speed_upgrade_stat_multiplier: float = 1.05
var friction_upgrade_stat_multiplier: float = 0.98
var bounciness_upgrade_stat_multiplier: float = 1.2
var xp_upgrade_stat_multiplier: float = 1.2
var score_upgrade_stat_multiplier: float = 1.2

# Perk vars
var double_speed_stack: int = 0
var double_speed_price: int = 50

# Initialise vars
var is_menu_open: bool = false
var base_bounciness: float = 1.0
var bounciness: float = base_bounciness
var friction_price: float = BASE_FRICTION_PRICE
var speed_price: float = BASE_SPEED_PRICE
var xp_price: float = BASE_XP_PRICE
var bounciness_price: float = BASE_BOUNCINESS_PRICE
var score_price: float = BASE_SCORE_PRICE

# Signals
@warning_ignore("unused_signal")
signal velocity_changed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the ball bounce signal
	ball.bounce.connect(_on_ball_bounce)
	update_price(speed_price_label,speed_price)
	update_price(friction_price_label, friction_price)
	update_price(xp_price_label, xp_price)
	update_price(bounciness_price_label, bounciness_price)
	update_price(score_price_label, score_price)
	
	update_stat(speed_button.stat_label, ball.current_speed, speed_upgrade_stat_multiplier)
	update_stat(friction_stat_label, ball.friction, friction_upgrade_stat_multiplier)
	update_stat(xp_stat_label, game.xp_gain, xp_upgrade_stat_multiplier)
	update_stat(bounciness_stat_label, bounciness, bounciness_upgrade_stat_multiplier)
	update_stat(score_stat_label, game.add, score_upgrade_stat_multiplier)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
		speed_price *= speed_upgrade_price_multiplier
		speed_button.update_price(speed_price)
		speed_button.update_stat(ball.current_speed, speed_upgrade_stat_multiplier)
		#update_price(speed_price_label, speed_price)
		#update_stat(speed_button.stat_label, ball.current_speed, speed_upgrade_stat_multiplier)
		emit_signal("velocity_changed", ball.current_speed)

func _on_speed2_pressed() -> void:
	if game.score >= speed_price:
		game.score -= speed_price
		ball.current_speed *= speed_upgrade_stat_multiplier
		ball.velocity *= speed_upgrade_stat_multiplier
		speed_price *= speed_upgrade_price_multiplier
		#speed_button.update_price(speed_price)
		speed_button.update_stat(ball.current_speed, speed_upgrade_stat_multiplier)
		update_price(speed_price_label, speed_price)
		#update_stat(speed_button.stat_label, ball.current_speed, speed_upgrade_stat_multiplier)
		emit_signal("velocity_changed", ball.current_speed)


# Bounciness effect on collide
func _on_ball_bounce() -> void:
	if snapped(ball.velocity.length(),2) <= ball.current_speed + ball.inverse_friction:
		ball.velocity *= bounciness
		emit_signal("velocity_changed", ball.velocity.length())

# Bounciness upgrade
func _on_bounciness_pressed() -> void:
	if game.score >= bounciness_price:
		game.score -= bounciness_price
		bounciness *= bounciness_upgrade_stat_multiplier
		bounciness_price *= bounciness_upgrade_price_multiplier
		update_price(bounciness_price_label, bounciness_price)
		update_stat(bounciness_stat_label, bounciness, bounciness_upgrade_stat_multiplier)

# Function to update price values on labels easier
func update_price(label: Label, price: float) -> void:
	label.text = str("Current Price: \n", snapped(price,0.01))

func update_stat(label: Label, stat: float, multiplier: float) -> void:
	label.text = str(snapped(stat, 0.01), " -> ", snapped(stat*multiplier, 0.01))

# Friction upgrade
func _on_friction_pressed() -> void:
	if game.score >= friction_price:
		game.score -= friction_price
		ball.friction *= friction_upgrade_stat_multiplier
		# Increase kinda ok
		ball.inverse_friction += pow(10 + (0.25 * friction_price), ball.friction)
		friction_price *= friction_upgrade_price_multiplier
		update_price(friction_price_label, friction_price)
		update_stat(friction_stat_label, ball.friction, friction_upgrade_stat_multiplier)


func _on_xp_gain_pressed() -> void:
	if game.score >= xp_price:
		game.score -= xp_price
		game.xp_gain *= xp_upgrade_stat_multiplier
		xp_price *= xp_upgrade_price_multiplier
		update_price(xp_price_label, xp_price)
		update_stat(xp_stat_label, game.xp_gain, xp_upgrade_stat_multiplier)


func _on_score_pressed() -> void:
	if game.score >= score_price:
		game.score -= score_price
		game.add *= score_upgrade_stat_multiplier
		score_price *= score_upgrade_price_multiplier
		update_price(score_price_label, score_price)
		update_stat(score_stat_label, game.add, score_upgrade_stat_multiplier)


func _on_double_speed_pressed() -> void:
	if game.gems >= double_speed_price:
		game.gems -= double_speed_price
		# Max of 3 stacks
		if double_speed_stack < 3:
			ball.velocity *= 2
			ball.current_speed *= 2
			emit_signal("velocity_changed", ball.current_speed)
			double_speed_stack += 1
			await get_tree().create_timer(60).timeout
			ball.current_speed /= 2
			double_speed_stack -= 1
			emit_signal("velocity_changed", ball.current_speed)
	

# ???
#func can_upgrade(price: float, stat, stat_multiplier: float, price_multiplier: float, price_label: Label, stat_label: Label) -> bool:
	#if game.score < price:
		#return false
	#else:
		#game.score -= price
		#stat *= stat_multiplier
		#price *= price_multiplier
		##update_price(price_label, price)
		##update_stat(stat_label, stat, stat_multiplier)
		#return true
