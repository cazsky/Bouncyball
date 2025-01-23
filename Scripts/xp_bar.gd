extends TextureProgressBar


func initialise(current, maximum) -> void:
	max_value = maximum
	value = current

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ball_experience_gained(growth_data: Variant) -> void:
	for line in growth_data:
		var target_experience = line[0]
		var max_experience = line[1]
		max_value = max_experience
		await animate_value(target_experience)
		if abs(value - max_value) < 0.01:
			value = min_value
		
func animate_value(target, tween_duration=0.2) -> void:
	var tw := get_tree().create_tween()
	tw.tween_property(self, "value", target, tween_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tw.finished
