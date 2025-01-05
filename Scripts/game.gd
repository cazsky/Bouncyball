extends Node2D

# Scene nodes
@onready var speed_label: Label = $Control/Stats/Speed
@onready var per_bounce_label: Label = $Control/Stats/PerBounce
@onready var score_label: Label = $Control/Stats/Score
@onready var ball: CharacterBody2D = $Ball

# Init variables
var score: int = 0
var add: int = 1
var combo: int = 0
var speed: float = 0 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = ball.speed
	score_label.text = str("Score: ", score)
	per_bounce_label.text = str("PerBounce: ", add)
	speed_label.text = str("Speed: ", speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score_label.text = str("Score: ", score)

# Prolly not needing this
func _on_click_pressed() -> void:
	score += add


func _on_ball_bounce() -> void:
	score += add
