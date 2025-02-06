extends Node2D

# Buttons
@onready var speed_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/Speed
@onready var friction_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/Friction
@onready var xp_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/XPGain
@onready var bounciness_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/Bounciness
@onready var score_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/Score

@onready var double_speed_button: UpgradeButton = $Control/TabContainer/Perks/GridContainer/Double_Speed
@onready var double_xp_button: UpgradeButton = $Control/TabContainer/Perks/GridContainer/Double_XP
@onready var double_score_button: UpgradeButton = $Control/TabContainer/Perks/GridContainer/Double_Score


@onready var popup: Button = $Control/Popup
@onready var arrow: Sprite2D = $Control/Arrow
@onready var ball: CharacterBody2D = $"../Ball"
@onready var game: Node2D = $"../../Game"

# Base upgrade price
const BASE_SPEED_PRICE: int = 10
const BASE_XP_PRICE: int = 50
const BASE_BOUNCINESS_PRICE: int = 150
const BASE_SCORE_PRICE: int = 500
const BASE_FRICTION_PRICE: int = 1000


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
var double_speed_price: int = 200
var double_xp_stack: int = 0
var double_xp_price: int = 500
var double_score_stack: int = 0
var double_score_price: int = 1000

# Initialise vars
var is_menu_open: bool = false
var base_bounciness: float = 1.0
var bounciness: float = base_bounciness
var friction_price: float = BASE_FRICTION_PRICE
var speed_price: float = BASE_SPEED_PRICE
var xp_price: float = BASE_XP_PRICE
var bounciness_price: float = BASE_BOUNCINESS_PRICE
var score_price: float = BASE_SCORE_PRICE
var max_stacks: int = 3

# Signals
@warning_ignore("unused_signal")
signal velocity_changed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the ball bounce signal
	ball.bounce.connect(_on_ball_bounce)
	speed_button.update_label(ball.current_speed, speed_upgrade_stat_multiplier, speed_price)
	bounciness_button.update_label(bounciness, bounciness_upgrade_stat_multiplier, bounciness_price)
	xp_button.update_label(game.xp_gain, xp_upgrade_stat_multiplier, xp_price)
	score_button.update_label(game.add, score_upgrade_stat_multiplier, score_price)
	friction_button.update_label(ball.friction, friction_upgrade_stat_multiplier, friction_price)
	
	double_speed_button.stat_label.text = str(double_speed_stack, " / ", max_stacks)
	double_speed_button.price_label.text = str("Current Price: ", "\n", double_speed_price)
	double_xp_button.stat_label.text = str(double_xp_stack, " / ", max_stacks)
	double_xp_button.price_label.text = str("Current Price: ", "\n", double_xp_price)
	double_score_button.stat_label.text = str(double_score_stack, " / ", max_stacks)
	double_score_button.price_label.text = str("Current Price: ", "\n", double_score_price)
	
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



func _on_speed_pressed() -> void:
	if game.score >= speed_price:
		game.score -= speed_price
		ball.current_speed *= speed_upgrade_stat_multiplier
		ball.velocity *= speed_upgrade_stat_multiplier
		speed_price *= speed_upgrade_price_multiplier
		speed_button.update_label(ball.current_speed, speed_upgrade_stat_multiplier, speed_price)
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
		bounciness_button.update_label(bounciness, bounciness_upgrade_stat_multiplier, bounciness_price)

# Friction upgrade
func _on_friction_pressed() -> void:
	if game.score >= friction_price:
		game.score -= friction_price
		ball.friction *= friction_upgrade_stat_multiplier
		# Increase kinda ok
		ball.inverse_friction += pow(10 + (0.25 * friction_price), ball.friction)
		friction_price *= friction_upgrade_price_multiplier
		friction_button.update_label(ball.friction, friction_upgrade_stat_multiplier, friction_price)


func _on_xp_gain_pressed() -> void:
	if game.score >= xp_price:
		game.score -= xp_price
		game.xp_gain *= xp_upgrade_stat_multiplier
		xp_price *= xp_upgrade_price_multiplier
		xp_button.update_label(game.xp_gain, xp_upgrade_stat_multiplier, xp_price)


func _on_score_pressed() -> void:
	if game.score >= score_price:
		game.score -= score_price
		game.add *= score_upgrade_stat_multiplier
		score_price *= score_upgrade_price_multiplier
		score_button.update_label(game.add, score_upgrade_stat_multiplier, score_price)


func _on_double_speed_pressed() -> void:
	if game.gems >= double_speed_price:
		game.gems -= double_speed_price
		if double_speed_stack < max_stacks:
			ball.velocity *= 2
			ball.current_speed *= 2
			emit_signal("velocity_changed", ball.current_speed)
			double_speed_stack += 1
			double_speed_button.stat_label.text = str(double_speed_stack, " / ", max_stacks)
			await get_tree().create_timer(60).timeout
			ball.current_speed /= 2
			double_speed_stack -= 1
			double_speed_button.stat_label.text = str(double_speed_stack, " / ", max_stacks)
			emit_signal("velocity_changed", ball.current_speed)
	

func _on_double_xp_pressed() -> void:
	if game.gems >= double_xp_price:
		game.gems -= double_xp_price
		if double_xp_stack < max_stacks:
			game.xp_gain *= 2
			double_xp_stack += 1
			double_xp_button.stat_label.text = str(double_xp_stack, " / ", max_stacks)
			await get_tree().create_timer(60).timeout
			game.xp_gain /= 2
			double_xp_stack -= 1
			double_xp_button.stat_label.text = str(double_xp_stack, " / ", max_stacks)


func _on_double_score_pressed() -> void:
	if game.gems >= double_score_price:
		game.gems -= double_score_price
		if double_score_stack < max_stacks:
			game.add *= 2
			double_score_stack += 1
			double_score_button.stat_label.text = str(double_score_stack, " / ", max_stacks)
			await get_tree().create_timer(60).timeout
			game.add /= 2
			double_score_stack -= 1
			double_score_button.stat_label.text = str(double_score_stack, " / ", max_stacks)
