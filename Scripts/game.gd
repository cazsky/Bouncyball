extends Node2D

# Scene nodes
@onready var score_label: Label = $Control/ScoreBox/Score
@onready var velocity_label: Label = $Control/Stats/Velocity
@onready var ball: CharacterBody2D = $Ball
@onready var xp_bar: TextureProgressBar = $Control/xp_bar

# Init variables
var score: float = 100000000
var add: float = 1
var combo: int = 0
var xp_gain: float = 5.0

func _init() -> void:
	# Randomise seed to start the game launching ball in random direction
	randomize()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xp_bar.initialise(ball.experience, ball.experience_required)
	score_label.text = str("Score: ", snapped(score, 0.01))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_label.text = str("Score: ", snapped(score, 0.01))
	velocity_label.text = str("Current velocity: ", snapped(ball.velocity.length(), 0.01))

func _on_ball_bounce() -> void:
	ball.gain_experience(xp_gain)
	score += add
