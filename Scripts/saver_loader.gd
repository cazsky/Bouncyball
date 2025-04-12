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
	load_game()

func save_game() -> void:
	var _save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var saved_game: SavedGame = SavedGame.new()
	
	saved_game.ball_position = ball.global_position
	saved_game.score = game.score
	saved_game.gems = game.gems
	
	saved_game.speed_upgrade_level = menu.speed_upgrade_level
	saved_game.bounciness_upgrade_level = menu.bounciness_upgrade_level
	saved_game.friction_upgrade_level = menu.friction_upgrade_level
	saved_game.xp_upgrade_level = menu.xp_upgrade_level
	saved_game.score_upgrade_level = menu.score_upgrade_level
	
	
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game() -> void:
	var saved_game: SavedGame = load("user://savegame.tres") as SavedGame
	if saved_game == null:
		return
	#
	ball.global_position = saved_game.ball_position
	game.score = saved_game.score
	game.gems = saved_game.gems


#func _on_tree_exited() -> void:
	#save_game()
#


func _on_button_pressed() -> void:
	save_game()


func _on_button_2_pressed() -> void:
	load_game()
