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

# Perk Timer Buttons
# Raises errors but timers exist on _ready()
@onready var double_speed_timer: Timer = $Control/TabContainer/Perks/GridContainer/Double_Speed/Double_Speed_Timer
@onready var double_xp_timer: Timer = $Control/TabContainer/Perks/GridContainer/Double_XP/Double_XP_Timer
@onready var double_bounce_timer: Timer = $Control/TabContainer/Perks/GridContainer/Double_Bounciness/Double_Bounciness_Timer
@onready var double_score_timer: Timer = $Control/TabContainer/Perks/GridContainer/Double_Score/Double_Score_Timer
@onready var double_ball_timer: Timer = $Control/TabContainer/Perks/GridContainer/Double_Ball/Double_Ball_Timer

# Ascension Buttons
@onready var ascend_button: AscensionButton = $Control/TabContainer/Ascension/GridContainer/Ascend
@onready var buy_relic_button: AscensionButton = $Control/TabContainer/Ascension/GridContainer/Buy_Relic

# Relic Buttons
@onready var owned_relics := $Control/TabContainer/Relics/GridContainer
@onready var stars_label: Label = $Control/TabContainer/Ascension/Star_Label


# Util Nodes
@onready var saver_loader: SaveLoader = $"../Utils/SaverLoader"

# UI and Game Nodes
@onready var popup: Button = $Control/Popup
@onready var arrow: Sprite2D = $Control/Arrow
@onready var ball: CharacterBody2D = $"../Ball"
@onready var game: Node2D = $"../../Game"
@onready var relic_pool: Array = [preload("res://Scenes/relics/increase_speed_relic.tscn"), preload("res://Scenes/relics/increase_score_relic.tscn"), preload("res://Scenes/relics/increase_bounce_relic.tscn"), preload("res://Scenes/relics/increase_xp_relic.tscn"), preload("res://Scenes/relics/increase_bounce_relic.tscn"),]
#@onready var relic_pool: Array = []
#@onready var relic_pool_number: int = 7
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
var speed_upgrade_discount: float = 1
var friction_upgrade_price_multiplier: float = 1.2
var friction_upgrade_discount: float = 1
var bounciness_upgrade_price_multiplier: float = 1.3
var bounciness_upgrade_discount: float = 1
var xp_upgrade_price_multiplier: float = 1.3
var xp_upgrade_discount: float = 1
var score_upgrade_price_multiplier: float = 1.3
var score_upgrade_discount: float = 1

# Ball stats upgrades multipliers
var speed_upgrade_stat_multiplier: float = 1.05
var friction_upgrade_stat_multiplier: float = 0.98
var bounciness_upgrade_stat_multiplier: float = 1.2
var xp_upgrade_stat_multiplier: float = 1.1
var score_upgrade_stat_multiplier: float = 1.2

# Ball upgrade levels
var speed_upgrade_level: int = 0
var friction_upgrade_level: int = 0
var bounciness_upgrade_level: int = 0
var xp_upgrade_level: int = 0
var score_upgrade_level: int = 0

# Perk vars
var double_speed_stack: int = 0
var double_speed_price: int = 200
var double_speed_time: int = 5
var double_speed_time_left: int = 0
var double_speed_is_active: bool = false
var double_speed_discount: float = 0

var double_xp_stack: int = 0
var double_xp_price: int = 500
var double_xp_time: int = 30
var double_xp_time_left: int = 0
var double_xp_is_active: bool = false
var double_xp_discount: float = 0

var double_bounce_stack: int = 0
var double_bounce_price: int  = 1000
var double_bounce_time: int = 30
var double_bounce_time_left: int = 0
var double_bounce_is_active: bool = false
var double_bounce_discount: float = 0

var double_score_stack: int = 0
var double_score_price: int = 2000
var double_score_time: int = 30
var double_score_time_left: int = 0
var double_score_is_active: bool = false
var double_score_discount: float = 0

var double_ball_stack: int = 0
var double_ball_price: int = 5000
var double_ball_time: int = 30
var double_ball_time_left: int = 0
var double_ball_is_active: bool = false
var double_ball_discount: float = 0

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
var global_discount: float = 1

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
	# Wait for game load
	await saver_loader.ready
	
	saver_loader.load_game()
	calculate_ball_stat_mults()
	# Hide relic tabs until requirements gotten
	if owned_relics.get_child_count() == 0:
		tab_container.set_tab_hidden(3, true)
		
	# Connect the ball bounce signal
	ball.bounce.connect(_on_ball_bounce)
	
	# Reload upgrade levels
	ball.update_stats()
	
	# Update menu labels 4head
	update_menu_labels()
	
	relic_pool = clean_relic_pool(owned_relics.get_children())
	
	ascend_button.price_label.text = ""
	stars_label.text = str("Stars: ", game.stars)
	print_debug(str("Stars: ", game.stars))
	
	#relic_pool = range(1, relic_pool_number+1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func update_upgrade_labels() -> void:
	# Update prices
	speed_price = BASE_SPEED_PRICE * pow(speed_upgrade_price_multiplier, speed_upgrade_level)
	bounciness_price = BASE_BOUNCINESS_PRICE * pow(bounciness_upgrade_price_multiplier, bounciness_upgrade_level)
	friction_price = BASE_FRICTION_PRICE * pow(friction_upgrade_price_multiplier, friction_upgrade_level)
	xp_price = BASE_XP_PRICE * pow(xp_upgrade_price_multiplier, xp_upgrade_level)
	score_price = BASE_SCORE_PRICE * pow(score_upgrade_price_multiplier, score_upgrade_level)
	
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
	update_menu_labels()
	
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


# Bounciness effect on collide
func _on_ball_bounce() -> void:
	if snapped(ball.velocity.length(),2) <= ball.current_speed + ball.inverse_friction:
		ball.velocity *= bounciness
		emit_signal("velocity_changed", ball.velocity.length())
		

func _on_speed_pressed() -> void:
	if game.score >= speed_price:
		game.score -= speed_price 
		speed_upgrade_level += 1
		
		speed_mult *= speed_upgrade_stat_multiplier
		ball.current_speed = (ball.base_speed * speed_mult * pow(2, double_speed_stack))
		ball.velocity = ball.velocity.normalized() * ball.base_speed * speed_mult * pow(2, double_speed_stack)
		speed_price = BASE_SPEED_PRICE * pow(speed_upgrade_price_multiplier, speed_upgrade_level) * (1/speed_upgrade_discount) * (1/global_discount)
		
		speed_button.update_label(ball.current_speed, speed_upgrade_stat_multiplier, speed_price)
		emit_signal("velocity_changed", ball.current_speed)



# Bounciness upgrade
func _on_bounciness_pressed() -> void:
	if game.score >= bounciness_price:
		game.score -= bounciness_price
		bounciness_upgrade_level += 1
		
		bounce_mult *= bounciness_upgrade_stat_multiplier
		bounciness = BASE_BOUNCINESS * bounce_mult * pow(2, double_bounce_stack) 
		
		bounciness_price = BASE_BOUNCINESS_PRICE * pow(bounciness_upgrade_price_multiplier, bounciness_upgrade_level) * (1/bounciness_upgrade_discount) * (1/global_discount)
		bounciness_button.update_label(bounciness, bounciness_upgrade_stat_multiplier, bounciness_price)

# Friction upgrade
func _on_friction_pressed() -> void:
	if game.score >= friction_price:
		game.score -= friction_price
		friction_upgrade_level += 1
		
		friction_mult *= friction_upgrade_stat_multiplier
		ball.friction = ball.base_friction * friction_mult
		# Increase kinda ok
		ball.inverse_friction += pow(10 + (0.25 * friction_price), ball.friction)
		friction_price = BASE_FRICTION_PRICE * pow(friction_upgrade_price_multiplier, friction_upgrade_level) * (1/friction_upgrade_discount) * (1/global_discount)
		friction_button.update_label(ball.friction, friction_upgrade_stat_multiplier, friction_price)


func _on_xp_gain_pressed() -> void:
	if game.score >= xp_price:
		game.score -= xp_price
		xp_upgrade_level += 1
		
		xp_mult *= xp_upgrade_stat_multiplier
		game.xp_gain = game.base_xp_gain * xp_mult * pow(2, double_xp_stack)
		xp_price = BASE_XP_PRICE * pow(xp_upgrade_price_multiplier, xp_upgrade_level) * (1/xp_upgrade_discount) * (1/global_discount)
		xp_button.update_label(game.xp_gain, xp_upgrade_stat_multiplier, xp_price)


func _on_score_pressed() -> void:
	if game.score >= score_price:
		game.score -= score_price
		score_upgrade_level += 1
		
		score_mult *= score_upgrade_stat_multiplier
		game.add = game.base_add * score_mult * pow(2, double_score_stack) 
		score_price = BASE_SCORE_PRICE * pow(score_upgrade_price_multiplier, score_upgrade_level)  * (1/xp_upgrade_discount) * (1/global_discount)
		score_button.update_label(game.add, score_upgrade_stat_multiplier, score_price)


func _on_double_speed_pressed() -> void:
	if game.gems >= double_speed_price:
		game.gems -= double_speed_price
		if double_speed_stack < max_stacks:
			activate_double_speed_perk()
	
func activate_double_speed_perk() -> void:
	double_speed_is_active = true
	double_speed_stack += 1
	# Keep default multipliers and double multipliers separate to prevent bugs
	ball.current_speed = ball.base_speed * speed_mult * pow(2, double_speed_stack)
	ball.velocity = ball.velocity.normalized() * ball.base_speed * speed_mult * pow(2, double_speed_stack)
	emit_signal("velocity_changed", ball.current_speed)
	double_speed_button.update_perk(double_speed_stack, max_stacks, double_speed_price)
	speed_button.update_label(ball.current_speed, speed_upgrade_stat_multiplier, speed_price)
	double_speed_timer.start(double_speed_time)
	await double_speed_timer.timeout
	double_speed_is_active = false
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
			activate_double_xp_perk()

func activate_double_xp_perk() -> void:
	double_xp_is_active = true
	double_xp_stack += 1
	game.xp_gain = game.base_xp_gain * xp_mult * pow(2, double_xp_stack)
	double_xp_button.update_perk(double_xp_stack, max_stacks, double_xp_price)
	xp_button.update_label(game.xp_gain, xp_upgrade_stat_multiplier, xp_price)
	double_xp_timer.start(double_xp_time)
	await double_xp_timer.timeout
	double_xp_is_active = false
	double_xp_stack -= 1
	game.xp_gain = game.base_xp_gain * xp_mult * pow(2, double_xp_stack)
	double_xp_button.update_perk(double_xp_stack, max_stacks, double_xp_price)
	xp_button.update_label(game.xp_gain, xp_upgrade_stat_multiplier, xp_price)

func _on_double_score_pressed() -> void:
	if game.gems >= double_score_price:
		game.gems -= double_score_price
		if double_score_stack < max_stacks:
			activate_double_score_perk()

func activate_double_score_perk() -> void:
	double_score_is_active = true
	double_score_stack += 1
	game.add = game.base_add * score_mult * pow(2, double_score_stack)
	double_score_button.update_perk(double_score_stack, max_stacks, double_score_price)
	score_button.update_label(game.add, score_upgrade_stat_multiplier, score_price)
	double_score_timer.start(double_score_time)
	await double_score_timer.timeout
	double_score_is_active = false
	double_score_stack -= 1
	game.add = game.base_add * score_mult * pow(2, double_score_stack)
	double_score_button.update_perk(double_score_stack, max_stacks, double_score_price)
	score_button.update_label(game.add, score_upgrade_stat_multiplier, score_price)
			
func _on_double_bounciness_pressed() -> void:
	if game.gems >= double_bounce_price:
		game.gems -= double_bounce_price
		if double_bounce_stack < max_stacks:
			activate_double_bounciness_perk()
			
func activate_double_bounciness_perk() -> void:
	double_bounce_is_active = true
	double_bounce_stack += 1
	bounciness = BASE_BOUNCINESS * bounce_mult * pow(2, double_bounce_stack)
	double_bounce_button.update_perk(double_bounce_stack, max_stacks, double_bounce_price)
	bounciness_button.update_label(bounciness, bounciness_upgrade_stat_multiplier, bounciness_price)
	double_bounce_timer.start(double_bounce_time)
	await double_bounce_timer.timeout
	double_bounce_is_active = false
	double_bounce_stack -= 1
	bounciness = BASE_BOUNCINESS * bounce_mult * pow(2, double_bounce_stack)
	double_bounce_button.update_perk(double_bounce_stack, max_stacks, double_bounce_price)
	bounciness_button.update_label(bounciness, bounciness_upgrade_stat_multiplier, bounciness_price)

func _on_double_ball_pressed() -> void:
	if game.gems >= double_ball_price:
		game.gems -= double_ball_price
		if double_ball_stack < max_stacks:
			activate_double_ball_perk()

func activate_double_ball_perk() -> void:
	double_ball_is_active = true
	double_ball_stack += 1
	var extra_ball = load("res://Scenes/ball.tscn").instantiate()
	extra_ball.bounce.connect(Callable(game, "_on_ball_bounce"))
	extra_ball.current_speed = ball.current_speed
	extra_ball.friction = ball.friction
	double_ball_button.update_perk(double_ball_stack, max_stacks, double_ball_price)
	extra_ball.global_position = ball.global_position/2
	get_parent().add_child.call_deferred(extra_ball)
	double_ball_timer.start(double_ball_time)
	await double_ball_timer.timeout
	double_ball_is_active = false
	get_parent().remove_child(extra_ball)
	double_ball_stack -= 1
	double_ball_button.update_perk(double_ball_stack, max_stacks, double_ball_price)

func _on_buy_relic_pressed() -> void:
	if game.stars >= relic_cost:
		if relic_pool.is_empty():
			print("No more relics for now")
			return
		game.stars -= relic_cost
		relic_cost = BASE_RELIC_PRICE * pow(relic_upgrade_price_multiplier, owned_relics.get_child_count())
		buy_relic_button.update_price(relic_cost)
		var template = relic_pool.pick_random()
		var new_relic = template.instantiate()
		# Remove bought relic from pool
		self.relic_pool.erase(template)
		owned_relics.add_wrapped_child(new_relic)
		stars_label.text = str("Stars: ", game.stars)
		tab_container.set_tab_hidden(3, false)
		

func _on_ascend_pressed() -> void:
	var stars = calculate_stars()
	if stars > 50:
		_reset_stats()
		game.stars += stars
	stars_label.text = str("Stars: ", game.stars)
	update_ascension_tab()
	
func calculate_stars() -> float:
	# Calculating stars for ascension
	var stars: int = -70
	var speed_star: float = ball.current_speed / pow(2, double_speed_stack)
	var bounce_star: float = bounciness / pow(2, double_bounce_stack)
	var xp_star: float = game.xp_gain / pow(2, double_xp_stack)
	var add_star: float = game.add / pow(2, double_score_stack)
	stars += int(sqrt(speed_star))
	stars += int(pow(2 * bounce_star, 2))
	stars += int(pow(5/ball.friction, 3) * 2)
	stars += int(pow(xp_star/2, 2) - xp_star/3)
	stars += int(5 + (add_star/3) + (pow(add_star, 1.3)/2))
	@warning_ignore("integer_division")
	stars += int(pow(game.score/5, 3/4))
	
	print_debug(stars)
	return stars
	
func _reset_stats() -> void:
	# Reset all stats
	speed_mult = 1
	bounce_mult = 1
	friction_mult = 1
	xp_mult = 1
	score_mult = 1
	
	ball.update_stats()
	
	game.score = game.base_score


func _on_ascended() -> void:
	tab_container.set_tab_hidden(3, true)


func _on_tab_container_tab_clicked(tab: int) -> void:
	# Update potential stars when ascension tab is clicked
	match tab:
		2:
			update_ascension_tab()

func update_menu_labels() -> void:
	update_ascension_tab()
	update_upgrade_labels()
	
	
func update_ascension_tab() -> void:
	# Calculate gains from ascension
	#var stars = calculate_stars()
	var stars_display = calculate_stars()
	ascend_button.disabled = true
	if stars_display < 0:
		stars_display = 0
	if stars_display >= 50:
		ascend_button.disabled = false
	ascend_button.price_label.text = str("Stars to gain: \n", snapped(stars_display, 0.01))

	# Calculate relic price
	relic_cost = BASE_RELIC_PRICE * pow(relic_upgrade_price_multiplier, owned_relics.get_child_count())
	buy_relic_button.update_price(relic_cost)

func _on_grid_container_child_entered_tree(_relic: Relic) -> void:
	ball.update_stats()


func calculate_ball_stat_mults() -> void:
	speed_mult = pow(speed_upgrade_stat_multiplier, speed_upgrade_level)
	bounce_mult = pow(bounciness_upgrade_stat_multiplier, bounciness_upgrade_level)
	friction_mult = pow(friction_upgrade_stat_multiplier, friction_upgrade_level)
	xp_mult = pow(xp_upgrade_stat_multiplier, xp_upgrade_level)
	score_mult = pow(score_upgrade_stat_multiplier, score_upgrade_level)
	
func activate_all_relics(relics: Array) -> void:
	for relic in relics:
		relic._activate_effect()
	
func clean_relic_pool(relics: Array) -> Array:
	var filtered: Array = []
	var found = false
	var instance
	for item in relic_pool:
		for r in relics:
			instance = item.instantiate()
			if r.get_child(0).relic_effect == instance.relic_effect:
				found = true
				break
		if not found:
			filtered.append(item)
		instance.queue_free()
	return filtered
	
	
