class_name SaverLoader
extends Node

@onready var ball: CharacterBody2D = get_tree().current_scene.get_node("Ball")
@onready var menu: Node2D = $"../../Menu"
@onready var game: Node2D = $"../.."

func save_game() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var saved_game: SavedGame = SavedGame.new()
	
	saved_game.ball_position = ball.global_position
	saved_game.score = game.score
	saved_game.gems = game.gems
	
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game() -> void:
	var saved_game: SavedGame = load("user://savegame.tres") as SavedGame
	
	ball.global_position = saved_game.ball_position
	game.score = saved_game.score
	game.gems = saved_game.gems
