extends Button
const SAVE_GAME_PATH: String = "user://savegame.tres"

@onready var menu = $"../../../../.."
@onready var saver_loader: SaverLoader = $Utils/SaverLoader
# Delete save
func _on_pressed() -> void:
	DirAccess.remove_absolute(SAVE_GAME_PATH)
	menu._reset_stats()
	menu.saver_loader.save_game()
	
