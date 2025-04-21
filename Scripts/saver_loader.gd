class_name SaverLoader
extends Node

@onready var ball: CharacterBody2D = get_tree().current_scene.get_node("Ball")
@onready var menu: Node2D = get_tree().current_scene.get_node("Menu") 
@onready var game: Node2D = get_tree().current_scene

# Order of calls
# 1. _init()
# 2. _enter_tree()
# 3. (tree_entered signal → _on_tree_entered() if connected)
# 4. _ready()
# Cant call load_game() before _ready() if defining vars at @onready

func _ready() -> void:
	# Load game when this is ready ig
	menu.calculate_ball_stat_mults()
	

func save_game() -> void:
	var _save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var saved_game: SavedGame = SavedGame.new()
	
	saved_game.ball_position = ball.global_position
	saved_game.score = game.score
	saved_game.gems = game.gems
	saved_game.ball_velocity = ball.velocity.length()
	
	saved_game.speed_upgrade_level = menu.speed_upgrade_level
	saved_game.bounciness_upgrade_level = menu.bounciness_upgrade_level
	saved_game.friction_upgrade_level = menu.friction_upgrade_level
	saved_game.xp_upgrade_level = menu.xp_upgrade_level
	saved_game.score_upgrade_level = menu.score_upgrade_level
	
	saved_game.double_speed_stack = menu.double_speed_stack
	saved_game.double_bounce_stack = menu.double_bounce_stack
	saved_game.double_xp_stack = menu.double_xp_stack
	saved_game.double_score_stack = menu.double_score_stack
	saved_game.double_ball_stack = menu.double_ball_stack
	
	saved_game.owned_relics = save_owned_relics()
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game() -> void:
	var saved_game: SavedGame = SafeResourceLoader.load("user://savegame.tres") as SavedGame
	
	if saved_game == null:
		print_debug("Saved game is null, abort")
		return
	#
	ball.global_position = saved_game.ball_position
	game.score = saved_game.score
	game.gems = saved_game.gems

	menu.speed_upgrade_level = saved_game.speed_upgrade_level
	menu.bounciness_upgrade_level = saved_game.bounciness_upgrade_level
	menu.friction_upgrade_level = saved_game.friction_upgrade_level
	menu.xp_upgrade_level = saved_game.xp_upgrade_level
	menu.score_upgrade_level = saved_game.score_upgrade_level
	
	menu.double_speed_stack = saved_game.double_speed_stack
	menu.double_bounce_stack = saved_game.double_bounce_stack
	menu.double_xp_stack = saved_game.double_xp_stack
	menu.double_score_stack = saved_game.double_score_stack
	menu.double_ball_stack = saved_game.double_ball_stack
	
	for saved_relic in saved_game.owned_relics:
		var relic = Relic.new()
		relic.relic_name = saved_relic.relic_name
		relic.cost = saved_relic.cost
		relic.cost_multiplier = saved_relic.cost_multiplier
		relic.stat_multiplier = saved_relic.stat_multiplier
		relic.level = saved_relic.level
		menu.owned_relics.add_child(relic)
	
	
func save_owned_relics() -> Array:
	var recorded_relics: Array = []
	for relic in menu.owned_relics.get_children():
		var saved_relic = SavedRelicData.new()
		saved_relic.relic_name = relic.relic_name
		saved_relic.cost = relic.cost
		saved_relic.cost_multiplier = relic.cost_multiplier
		saved_relic.stat_multiplier = relic.stat_multiplier
		saved_relic.level = relic.level
		recorded_relics.append(saved_relic)
	
	return recorded_relics
	
	
func _on_button_pressed() -> void:
	save_game()


func _on_button_2_pressed() -> void:
	load_game()
