extends Button
const SAVE_GAME_PATH: String = "user://savegame.tres"

# Delete save
func _on_pressed() -> void:
	DirAccess.remove_absolute(SAVE_GAME_PATH)
