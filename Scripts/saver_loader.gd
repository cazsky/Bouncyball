class_name SaverLoader
extends Node

#@onready var ball: CharacterBody2D = get_tree().current_scene.get_node("Ball")
#@onready var menu: Node2D = get_tree().current_scene.get_node("Menu")
#@onready var game: Node2D = get_tree().current_scene

# Cant define on 
@onready var ball: CharacterBody2D
@onready var menu: Node2D
@onready var game: Node2D

func _ready() -> void:
	ball = get_tree().current_scene.get_node("Ball")
	menu = get_tree().current_scene.get_node("Menu")
	game = get_tree().current_scene

	# Load game when this is ready ig
	load_game()

func save_game() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var saved_game: SavedGame = SavedGame.new()
	
	saved_game.ball_position = ball.global_position
	saved_game.score = game.score
	saved_game.gems = game.gems
	
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
