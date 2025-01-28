extends TextureProgressBar

@onready var label: Label = $Label
@onready var level_label: Label = $level
@onready var ball: CharacterBody2D = $"../../Ball"

func initialise(current, maximum) -> void:
	max_value = maximum
	value = current
	label.text = str(" ", snapped(value, 0.02), " / ", max_value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_label.text = str(ball.level, " ")
	ball.levelled_up.connect(_on_ball_levelled_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_ball_experience_gained(growth_data: Variant) -> void:
	for line in growth_data:
		var target_experience = line[0]
		var max_experience = line[1]
		max_value = max_experience
		label.text = str(" ", snapped(target_experience, 0.02), " / ", max_experience)
		await animate_value(target_experience)
		if abs(value - max_value) < 0.01:
			value = min_value
	
		
func animate_value(target, tween_duration=0.1) -> void:
	var tw := get_tree().create_tween()
	tw.tween_property(self, "value", target, tween_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tw.finished
	
func _on_ball_levelled_up(level: int) -> void:
	level_label.text = str(level, " ")
