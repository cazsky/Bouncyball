extends Node2D

# Upgrade Buttons
@onready var speed_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/Speed
@onready var friction_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/Friction
@onready var xp_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/XPGain
@onready var bounciness_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/Bounciness
@onready var score_button: UpgradeButton = $Control/TabContainer/Upgrades/GridContainer/Score

# Perk Buttons
@onready var double_speed_button: PerkButton = $Control/TabContainer/Perks/GridContainer/Double_Speed
@onready var double_xp_button: PerkButton = $Control/TabContainer/Perks/GridContainer/Double_XP
@onready var double_score_button: PerkButton = $Control/TabContainer/Perks/GridContainer/Double_Score
@onready var double_bounce_button: PerkButton = $Control/TabContainer/Perks/GridContainer/Double_Bounciness
@onready var double_ball_button: PerkButton = $Control/TabContainer/Perks/GridContainer/Double_Ball

# Ascension Buttons
@onready var ascend_button: AscensionButton = $Control/TabContainer/Ascension/GridContainer/Ascend
@onready var buy_relic_button: AscensionButton = $Control/TabContainer/Ascension/GridContainer/Buy_Relic

# Relic Buttons
@onready var owned_relics := $Control/TabContainer/Relics/GridContainer
@onready var stars_label: Label = $Control/TabContainer/Ascension/Star_Label


@onready var popup: Button = $Control/Popup
@onready var arrow: Sprite2D = $Control/Arrow
@onready var ball: CharacterBody2D = $"../Ball"
@onready var game: Node2D = $"../../Game"
@onready var relics: Array = [preload("res://Scenes/relics/increase_speed_relic.tscn")]
@onready var tab_container: TabContainer = $Control/TabContainer

# Base upgrade price
const BASE_SPEED_PRICE: int = 5
const BASE_XP_PRICE: int = 30
const BASE_BOUNCINESS_PRICE: int = 75
const BASE_SCORE_PRICE: int = 200
const BASE_FRICTION_PRICE: int = 500
const BASE_RELIC_PRICE:int = 10

# Base stats
const BASE_BOUNCINESS: float = 1

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

# Ball upgrade levels
var speed_upgrade_level: float = 1
var friction_upgrade_level: float = 1
var bounciness_upgrade_level: float = 1
var xp_upgrade_level: float = 1
var score_upgrade_level: float = 1

# Perk vars
var double_speed_stack: int = 0
var double_speed_price: int = 200
var double_speed_time: int = 5
var double_xp_stack: int = 0
var double_xp_price: int = 500
var double_xp_time: int = 30
var double_bounce_stack: int = 0
var double_bounce_price = 1000
var double_bounce_time: int = 30
var double_score_stack: int = 0
var double_score_price: int = 2000
var double_score_time: int = 30
var double_ball_stack: int = 0
var double_ball_price: int = 5000
var double_ball_time: int = 30

# Current stats
var speed_mult: float = 1
var xp_mult: float = 1
var bounce_mult: float = 1
var score_mult: float = 1
var friction_mult: float = 1

# Ascension Vars
var relic_price: float = BASE_RELIC_PRICE
var relic_price_multiplier: float = 2.5
var relic_upgrade_price_multiplier: float = 1.5
var relic_upgrade_stat_multiplier: float = 1.1



# Initialise vars
var is_menu_open: bool = false
var bounciness: float = BASE_BOUNCINESS
var max_stacks: int = 3

var friction_price: float = BASE_FRICTION_PRICE
var speed_price: float = BASE_SPEED_PRICE
var xp_price: float = BASE_XP_PRICE
var bounciness_price: float = BASE_BOUNCINESS_PRICE
var score_price: float = BASE_SCORE_PRICE

@onready var relic_cost: float = BASE_RELIC_PRICE * pow(relic_upgrade_price_multiplier, owned_relics.get_child_count())

# Signals
@warning_ignore("unused_signal")
# Connected to border.gd in the Game scene
signal velocity_changed
@warning_ignore("unused_signal")
signal ascended




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide relic tabs until requirements gotten
	if owned_relics.get_child_count() == 0:
		tab_container.set_tab_hidden(3, true)
		
	# Connect the ball bounce signal
	ball.bounce.connect(_on_ball_bounce)
	
	# Update upgrade buttons labels
	speed_button.update_label(ball.current_speed, speed_upgrade_stat_multiplier, speed_price)
	bounciness_button.update_label(bounciness, bounciness_upgrade_stat_multiplier, bounciness_price)
	xp_button.update_label(game.xp_gain, xp_upgrade_stat_multiplier, xp_price)
	score_button.update_label(game.add, score_upgrade_stat_multiplier, score_price)
	friction_button.update_label(ball.friction, friction_upgrade_stat_multiplier, friction_price)
	
	# Update perk button labels
	double_speed_button.update_perk(double_speed_stack, max_stacks, double_speed_price)
	double_xp_button.update_perk(double_xp_stack, max_stacks, double_xp_price)
	double_score_button.update_perk(double_score_stack, max_stacks, double_score_price)
	double_bounce_button.update_perk(double_bounce_stack, max_stacks, double_bounce_price)
	double_ball_button.update_perk(double_ball_stack, max_stacks, double_ball_price)
	
	ascend_button.price_label.text = ""
	stars_label.text = str("Stars: ", game.stars)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func save() -> Dictionary:
	var save_dict = {
		# Game vars
		"pos_x" : ball.position.x,
		"pos_y" : ball.position.y,
		"score" : game.score,
		"gems" : game.gems,
		# Ball stats
		"current_speed" : ball.current_speed,
		"speed_upgrade_level" : speed_upgrade_level,
		"bounciness_upgrade_level" : bounciness_upgrade_level,
		"friction_upgrade_level" : friction_upgrade_level,
		"xp_upgrade_level" : xp_upgrade_level,
		"score_upgrade_level" : score_upgrade_level,
		# Double stacks
		"double_speed_stack" : double_speed_stack,
		"double_bounce_stack" : double_bounce_stack,
		"double_xp_stack" : double_xp_stack,
		"double_score_button" : double_score_button,
		"double_ball_stack" : double_ball_stack,
 	}
	
	return save_dict
	
func save_game() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check if the node is an instanced scene so it can be instanced again during load
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		#Check if the node has a save function
	
func load_game() -> void:
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
		#ball.current_speed *= speed_upgrade_stat_multiplier
		speed_mult *= speed_upgrade_stat_multiplier
		ball.current_speed = ball.base_speed * speed_mult * pow(2, double_speed_stack)
		ball.velocity = ball.velocity.normalized() * ball.base_speed * speed_mult * pow(2, double_speed_stack)
		speed_upgrade_level += 1
		speed_price = BASE_SPEED_PRICE * pow(speed_upgrade_price_multiplier, speed_upgrade_level)
		
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
		bounce_mult *= bounciness_upgrade_stat_multiplier
		bounciness = BASE_BOUNCINESS * bounce_mult * pow(2, double_bounce_stack)
		bounciness_upgrade_level += 1
		bounciness_price = BASE_BOUNCINESS_PRICE * pow(bounciness_upgrade_price_multiplier, bounciness_upgrade_level)
		bounciness_button.update_label(bounciness, bounciness_upgrade_stat_multiplier, bounciness_price)

# Friction upgrade
func _on_friction_pressed() -> void:
	if game.score >= friction_price:
		game.score -= friction_price
		friction_mult *= friction_upgrade_stat_multiplier
		ball.friction = ball.base_friction * friction_mult
		# Increase kinda ok
		ball.inverse_friction += pow(10 + (0.25 * friction_price), ball.friction)
		friction_upgrade_level += 1
		friction_price = BASE_FRICTION_PRICE * pow(friction_upgrade_price_multiplier, friction_upgrade_level)
		friction_button.update_label(ball.friction, friction_upgrade_stat_multiplier, friction_price)


func _on_xp_gain_pressed() -> void:
	if game.score >= xp_price:
		game.score -= xp_price
		xp_mult *= xp_upgrade_stat_multiplier
		game.xp_gain = game.base_xp_gain * xp_mult * pow(2, double_xp_stack)
		#game.xp_gain *= xp_upgrade_stat_multiplier
		xp_upgrade_level += 1
		xp_price = BASE_XP_PRICE * pow(xp_upgrade_price_multiplier, xp_upgrade_level)
		xp_button.update_label(game.xp_gain, xp_upgrade_stat_multiplier, xp_price)


func _on_score_pressed() -> void:
	if game.score >= score_price:
		game.score -= score_price
		score_mult *= score_upgrade_stat_multiplier 
		game.add = game.base_add * score_mult * pow(2, double_score_stack)
		score_upgrade_level += 1
		score_price = BASE_SCORE_PRICE * pow(score_upgrade_price_multiplier, score_upgrade_level)
		score_button.update_label(game.add, score_upgrade_stat_multiplier, score_price)


func _on_double_speed_pressed() -> void:
	if game.gems >= double_speed_price:
		game.gems -= double_speed_price
		if double_speed_stack < max_stacks:
			double_speed_stack += 1
			#speed_mult *= 2
			#ball.current_speed = ball.base_speed * speed_mult
			# Keep default multipliers and double multipliers separate to prevent bugs
			ball.current_speed = ball.base_speed * speed_mult * pow(2, double_speed_stack)
			ball.velocity = ball.velocity.normalized() * ball.base_speed * speed_mult * pow(2, double_speed_stack)
			emit_signal("velocity_changed", ball.current_speed)
			double_speed_button.update_perk(double_speed_stack, max_stacks, double_speed_price)
			speed_button.update_label(ball.current_speed, speed_upgrade_stat_multiplier, speed_price)
			await get_tree().create_timer(double_speed_time).timeout
			double_speed_stack -= 1
			ball.current_speed = ball.base_speed * speed_mult * pow(2, double_speed_stack)
			ball.velocity = ball.velocity.normalized() * ball.base_speed * speed_mult * pow(2, double_speed_stack)
			double_speed_button.update_perk(double_speed_stack, max_stacks, double_speed_price)
			emit_signal("velocity_changed", ball.current_speed)
			speed_button.update_label(ball.current_speed, speed_upgrade_stat_multiplier, speed_price)

func _on_double_xp_pressed() -> void:
	if game.gems >= double_xp_price:
		game.gems -= double_xp_price
		if double_xp_stack < max_stacks:
			double_xp_stack += 1
			game.xp_gain = game.base_xp_gain * xp_mult * pow(2, double_xp_stack)
			double_xp_button.update_perk(double_xp_stack, max_stacks, double_xp_price)
			xp_button.update_label(game.xp_gain, xp_upgrade_stat_multiplier, xp_price)
			await get_tree().create_timer(double_xp_time).timeout
			double_xp_stack -= 1
			game.xp_gain = game.base_xp_gain * xp_mult * pow(2, double_xp_stack)
			double_xp_button.update_perk(double_xp_stack, max_stacks, double_xp_price)
			xp_button.update_label(game.xp_gain, xp_upgrade_stat_multiplier, xp_price)

func _on_double_score_pressed() -> void:
	if game.gems >= double_score_price:
		game.gems -= double_score_price
		if double_score_stack < max_stacks:
			double_score_stack += 1
			game.add = game.base_add * score_mult * pow(2, double_score_stack)
			double_score_button.update_perk(double_score_stack, max_stacks, double_score_price)
			score_button.update_label(game.add, score_upgrade_stat_multiplier, score_price)
			await get_tree().create_timer(double_score_time).timeout
			double_score_stack -= 1
			game.add = game.base_add * score_mult * pow(2, double_score_stack)
			double_score_button.update_perk(double_score_stack, max_stacks, double_score_price)
			score_button.update_label(game.add, score_upgrade_stat_multiplier, score_price)

			
			
func _on_double_bounciness_pressed() -> void:
	if game.gems >= double_bounce_price:
		game.gems -= double_bounce_price
		if double_bounce_stack < max_stacks:
			double_bounce_stack += 1
			bounciness = BASE_BOUNCINESS * bounce_mult * pow(2, double_bounce_stack)
			double_bounce_button.update_perk(double_bounce_stack, max_stacks, double_bounce_price)
			bounciness_button.update_label(bounciness, bounciness_upgrade_stat_multiplier, bounciness_price)
			await get_tree().create_timer(double_bounce_time).timeout
			double_bounce_stack -= 1
			bounciness = BASE_BOUNCINESS * bounce_mult * pow(2, double_bounce_stack)
			double_bounce_button.update_perk(double_bounce_stack, max_stacks, double_bounce_price)
			bounciness_button.update_label(bounciness, bounciness_upgrade_stat_multiplier, bounciness_price)


func _on_double_ball_pressed() -> void:
	if game.gems >= double_ball_price:
		game.gems -= double_ball_price
		if double_ball_stack < max_stacks:
			double_ball_stack += 1
			var extra_ball = load("res://Scenes/ball.tscn").instantiate()
			extra_ball.bounce.connect(Callable(game, "_on_ball_bounce"))
			extra_ball.current_speed = ball.current_speed
			extra_ball.friction = ball.friction
			double_ball_button.update_perk(double_ball_stack, max_stacks, double_ball_price)
			extra_ball.global_position = ball.global_position/2
			get_parent().add_child(extra_ball)
			await get_tree().create_timer(double_ball_time).timeout
			get_parent().remove_child(extra_ball)
			double_ball_stack -= 1
			double_ball_button.update_perk(double_ball_stack, max_stacks, double_ball_price)

func _on_buy_relic_pressed() -> void:
	if game.stars >= relic_cost:
		game.stars -= relic_cost
		relic_cost = BASE_RELIC_PRICE * pow(relic_upgrade_price_multiplier, owned_relics.get_child_count())
		buy_relic_button.update_price(relic_cost)
		var new_relic = relics.pick_random().instantiate()
		new_relic.menu = self
		owned_relics.add_child(new_relic)
		stars_label.text = str("Stars: ", game.stars)
		tab_container.set_tab_hidden(3, false)

func _on_ascend_pressed() -> void:
	game.stars += _reset_stats()
	stars_label.text = str("Stars: ", game.stars)
	
func calculate_stars() -> float:
	# Calculating stars for ascension
	var stars: int = -70
	var speed_star: float = ball.current_speed / pow(2, double_speed_stack)
	var bounce_star: float = bounciness / pow(2, double_bounce_stack)
	var xp_star: float = game.xp_gain / pow(2, double_xp_stack)
	var add_star: float = game.add / pow(2, double_score_stack)
	stars += int(sqrt(speed_star))
	#print_debug("Speed Stars: ", stars)
	stars += int(pow(2 * bounce_star, 2))
	#print_debug("Bounce Stars: ", stars)
	stars += int(pow(5/ball.friction, 3) * 2)
	#print_debug("Friction Stars: ", stars)
	stars += int(pow(xp_star/2, 2) - xp_star/3)
	#print_debug("XP Stars: ", stars)
	stars += int(5 + (add_star/3) + (pow(add_star, 1.3)/2))
	#print_debug("Score Stars: ", stars)
	# Yeah idk man
	@warning_ignore("integer_division")
	stars += int(pow(game.score/5, 3/4))
	#print_debug("Stars: ", stars)
	
	print_debug(stars)
	return stars
	
func _reset_stats() -> float:
	var stars = calculate_stars()
	if stars > 50:
		# Reset all stats
		speed_mult = 1
		bounce_mult = 1
		friction_mult = 1
		xp_mult = 1
		score_mult = 1
		
		ball.current_speed = ball.base_speed * speed_mult * pow(2, double_speed_stack)
		bounciness = BASE_BOUNCINESS * bounce_mult * pow(2, double_bounce_stack)
		ball.friction = ball.base_friction * friction_mult
		game.xp_gain = game.base_xp_gain * xp_mult * pow(2, double_xp_stack)
		game.add = game.base_add * score_mult* pow(2, double_score_stack)
		
		game.score = game.base_score
	else:
		stars = 0
	return stars



func _on_ascended() -> void:
	tab_container.set_tab_hidden(3, true)


func _on_tab_container_tab_clicked(tab: int) -> void:
	# Update potential stars when ascension tab is clicked
	match tab:
		2:
			# Calculate gains from ascension
			var stars = calculate_stars()
			var stars_display = stars
			ascend_button.disabled = true
			if stars_display < 0:
				stars_display = 0
			if stars >= 50:
				ascend_button.disabled = false
			ascend_button.price_label.text = str("Stars to gain: \n", stars_display)
			
			# Calculate relic price
			relic_cost = BASE_RELIC_PRICE * pow(relic_upgrade_price_multiplier, owned_relics.get_child_count())
			buy_relic_button.update_price(relic_cost)


func _on_grid_container_child_entered_tree(relic: Relic) -> void:
	relic.activate_effect()
	ball.update_stats()
