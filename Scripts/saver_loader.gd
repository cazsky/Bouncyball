class_name SaverLoader
extends Node

@onready var ball: CharacterBody2D = get_tree().current_scene.get_node("Ball")
@onready var menu: Node2D = get_tree().current_scene.get_node("Menu") 
@onready var game: Node2D = get_tree().current_scene


const SAVE_RELIC_PATH: String = "user://SavedRelics.tres"
const SAVE_GAME_PATH: String = "user://savegame.tres"
const SAVE_PERK_PATH: String =  "user://saveperk.tres"

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
	
	var saved_game: SavedGame = SavedGame.new()
	
	saved_game.ball_position = ball.global_position
	saved_game.score = game.score
	saved_game.gems = game.gems
	saved_game.ball_velocity = ball.velocity.length()
	saved_game.stars = game.stars
	
	saved_game.speed_upgrade_level = menu.speed_upgrade_level
	saved_game.bounciness_upgrade_level = menu.bounciness_upgrade_level
	saved_game.friction_upgrade_level = menu.friction_upgrade_level
	saved_game.xp_upgrade_level = menu.xp_upgrade_level
	saved_game.score_upgrade_level = menu.score_upgrade_level
	

	saved_game.relic_pool = menu.relic_pool
	save_relics()
	save_perks()
	ResourceSaver.save(saved_game, SAVE_GAME_PATH)
	
func load_game() -> void:
	var saved_game: SavedGame = SafeResourceLoader.load(SAVE_GAME_PATH) as SavedGame
	
	if saved_game == null:
		print_debug("Saved game is null, abort")
		return
	#
	ball.global_position = saved_game.ball_position
	game.score = saved_game.score
	game.gems = saved_game.gems
	game.stars = saved_game.stars

	menu.speed_upgrade_level = saved_game.speed_upgrade_level
	menu.bounciness_upgrade_level = saved_game.bounciness_upgrade_level
	menu.friction_upgrade_level = saved_game.friction_upgrade_level
	menu.xp_upgrade_level = saved_game.xp_upgrade_level
	menu.score_upgrade_level = saved_game.score_upgrade_level
	
	menu.relic_pool = saved_game.relic_pool
	clear_relics()
	load_relics()
	
	load_perks()
	
	
func save_relics() -> void:
	var node_to_save = menu.owned_relics.get_children()
	var relic_collection = SavedRelicCollection.new()
	for relic in node_to_save:
		var relic_to_save = SavedRelicData.new()
		relic_to_save.scene_path = relic.scene_path
		relic_to_save.cost_multiplier = relic.cost_multiplier
		relic_to_save.stat_multiplier = relic.stat_multiplier
		relic_to_save.relic_name = relic.relic_name
		relic_to_save.level = relic.level
		relic_collection.owned_relics.append(relic_to_save)
	ResourceSaver.save(relic_collection, SAVE_RELIC_PATH)
	
func load_relics() -> void:
	# Check if there are any relics saved
	if !FileAccess.file_exists(SAVE_RELIC_PATH):
		return
	else:
		var loaded_collection = ResourceLoader.load(SAVE_RELIC_PATH) as SavedRelicCollection
		for relic in loaded_collection.owned_relics:
			var relic_to_load = load(relic.scene_path).instantiate()
			relic_to_load.cost_multiplier = relic.cost_multiplier
			relic_to_load.stat_multiplier = relic.stat_multiplier
			relic_to_load.relic_name = relic.relic_name
			relic_to_load.level = relic.level
			#(relic.script_path)
			menu.owned_relics.add_child(relic_to_load)
	
func load_perks() -> void:
	# Check if save file exists
	if !FileAccess.file_exists(SAVE_PERK_PATH):
		return
	else:
		var loaded_perks = ResourceLoader.load(SAVE_PERK_PATH) as SavedPerkData
		# Double Speed
		menu.double_speed_stack = loaded_perks.double_speed_stack
		menu.double_speed_price = loaded_perks.double_speed_price
		menu.double_speed_time = loaded_perks.double_speed_time
		menu.double_speed_time_left = loaded_perks.double_speed_time_left

		# Double XP
		menu.double_xp_stack = loaded_perks.double_xp_stack
		menu.double_xp_price = loaded_perks.double_xp_price
		menu.double_xp_time = loaded_perks.double_xp_time
		menu.double_xp_time_left = loaded_perks.double_xp_time_left
		
		# Double Bounce
		menu.double_bounce_stack = loaded_perks.double_bounce_stack
		menu.double_bounce_price = loaded_perks.double_bounce_price
		menu.double_bounce_time = loaded_perks.double_bounce_time
		menu.double_bounce_time_left = loaded_perks.double_bounce_time_left
		
		# Double Score
		menu.double_score_stack = loaded_perks.double_score_stack
		menu.double_score_price = loaded_perks.double_score_price
		menu.double_score_time = loaded_perks.double_score_time
		menu.double_score_time_left = loaded_perks.double_score_time_left
		
		#Double Ball
		menu.double_ball_stack = loaded_perks.double_ball_stack
		menu.double_ball_price = loaded_perks.double_ball_price
		menu.double_ball_time = loaded_perks.double_ball_time
		menu.double_ball_time_left = loaded_perks.double_ball_time_left

	
func save_perks() -> void:
	var saved_perk_data = SavedPerkData.new()
	
	# Double Speed
	saved_perk_data.double_speed_stack = menu.double_speed_stack
	saved_perk_data.double_speed_price = menu.double_speed_price
	saved_perk_data.double_speed_time = menu.double_speed_time
	saved_perk_data.double_speed_time_left = menu.double_speed_time_left
	
	# Double XP
	saved_perk_data.double_xp_stack = menu.double_xp_stack
	saved_perk_data.double_xp_price = menu.double_xp_price
	saved_perk_data.double_xp_time = menu.double_xp_time
	saved_perk_data.double_xp_time_left = menu.double_xp_time_left
	
	# Double Bounce
	saved_perk_data.double_bounce_stack = menu.double_bounce_stack
	saved_perk_data.double_bounce_price = menu.double_bounce_price
	saved_perk_data.double_bounce_time = menu.double_bounce_time
	saved_perk_data.double_bounce_time_left = menu.double_bounce_time_left
	
	# Double Score
	saved_perk_data.double_score_stack = menu.double_score_stack
	saved_perk_data.double_score_price = menu.double_score_price
	saved_perk_data.double_score_time = menu.double_score_time
	saved_perk_data.double_score_time_left = menu.double_score_time_left
	
	# Double Ball
	saved_perk_data.double_ball_stack = menu.double_ball_stack
	saved_perk_data.double_ball_price = menu.double_ball_price
	saved_perk_data.double_ball_time = menu.double_ball_time
	saved_perk_data.double_ball_time_left = menu.double_ball_time_left
		
	ResourceSaver.save(saved_perk_data, SAVE_PERK_PATH)


func clear_relics() -> void:
	# Relics duplicate when manually loading multiple times
	for relic in menu.owned_relics.get_children():
		menu.owned_relics.remove_child(relic)
	
func _on_button_pressed() -> void:
	save_game()


func _on_button_2_pressed() -> void:
	load_game()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		# Putting get_tree().quit() would make things weird I think
		save_game()
