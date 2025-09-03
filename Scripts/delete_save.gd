extends Button
const SAVE_GAME_PATH: String = "user://savegame.tres"

@onready var menu = $"../../../../.."

# Delete save
func _on_pressed() -> void:
	menu._reset_stats()
	DirAccess.remove_absolute(SAVE_GAME_PATH)
