extends Line2D

@export var grad: Gradient
@export var speed := 1.0

var pos := 0.0
var follows := []

@onready var ball: CharacterBody2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 10:
		var new_follow = PathFollow2D.new()
		ball.add_child(new_follow)
		new_follow.progress = float(i*0.02)
		follows.append(new_follow)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	clear_points()
	for f in follows:
		f.progress = wrapf(f.progress + delta * speed, 0, 1)
		add_point(f.global_position)
		
	gradient.colors[0] = grad.get_color(follows[0].progress)
	gradient.colors[1] = grad.get_color(follows[-1].progress)
