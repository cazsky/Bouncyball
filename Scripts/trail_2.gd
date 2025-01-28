extends Line2D
class_name Trails

var queue: Array 

@export var MAX_LENGTH: int = 200

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var pos = get_parent().position
	var pos = _get_position()
	
	queue.push_front(pos)
	
	if queue.size() >= MAX_LENGTH:
		queue.pop_back()
		
	clear_points()
	
	for point in queue:
		add_point(point)

func _get_position():
	return get_parent().global_position
	#return get_global_mouse_position()
