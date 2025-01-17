extends Node2D

# Scene nodes
@onready var score_label: Label = $Control/ScoreBox/Score
@onready var velocity_label: Label = $Control/Stats/Velocity
@onready var ball: CharacterBody2D = $Ball

# Init variables
var score: int = 0
var add: int = 1
var combo: int = 0

func _init() -> void:
	# Randomise seed to start the game launching ball in random direction
	randomize()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = str("Score: ", score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_label.text = str("Score: ", score)
	velocity_label.text = str("Velocity: ", snapped(ball.velocity.length(), 0.01))

func _on_ball_bounce() -> void:
	score += add
