extends Button
const SAVE_GAME_PATH: String = "user://savegame.tres"

@onready var menu = $"../../../../.."

# Delete save
func _on_pressed() -> void:
	DirAccess.remove_absolute(SAVE_GAME_PATH)
	menu._reset_stats()
	menu.game.stars = 0
	menu.stars_label.text = str("Stars: ", menu.game.stars)
	menu.game.gems = 0
	remove_owned_relics()
	menu.saver_loader.save_game()
	print_debug(menu.game)
	
func remove_owned_relics() -> void:
	var owned_relics = menu.owned_relics.get_children()
	for relic in owned_relics:
		menu.owned_relics.remove_child(relic)
