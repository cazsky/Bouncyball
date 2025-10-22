extends Button
const SAVE_GAME_PATH: String = "user://savegame.tres"

@onready var menu = $"../../../../.."

# Delete save
func _on_pressed() -> void:
	DirAccess.remove_absolute(SAVE_GAME_PATH)
	menu._reset_stats()
	menu.game.stars = 0
	menu.game.stars_label.text = 0
	menu.game.gems = 0
	menu.saver_loader.save_game()
	print_debug(menu.game)
	

	
