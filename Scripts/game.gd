extends Node2D

# Scene nodes
@onready var per_bounce_label: Label = $Control/Stats/PerBounce
@onready var score_label: Label = $Control/ScoreBox/Score
@onready var velocity_label: Label = $Control/Stats/Velocity
@onready var ball: CharacterBody2D = $Ball

# Init variables
var score: int = 100
var add: int = 1
var speed: float = 0 

func _init() -> void:
	# Randomise seed to start the game launching ball in random direction
	randomize()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = ball.current_speed
	score_label.text = str("Score: ", score)
	per_bounce_label.text = str("PerBounce: ", add)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_label.text = str("Score: ", score)
	velocity_label.text = str("Velocity: ", snapped(ball.velocity.length(), 0.01))

func _on_ball_bounce() -> void:
	score += add
