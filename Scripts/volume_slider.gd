extends HSlider

@export var master_volume: String = "Master"
var master_volume_index: int = -1

func _ready() -> void:
	master_volume_index = AudioServer.get_bus_index(master_volume)
	var db = AudioServer.get_bus_volume_db(master_volume_index)
	self.value = db_to_linear(db)
	


func _on_changed() -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(master_volume_index, db)
