extends Node2D

# Scene nodes
@onready var score_label: Label = $Control/ScoreBox/Score
@onready var velocity_label: Label = $Control/Stats/Velocity
@onready var ball: CharacterBody2D = $Ball
@onready var xp_bar: TextureProgressBar = $Control/xp_bar
@onready var gems_label: Label = $Control/GemsLabel
@onready var reset_ball_button: Button = $Control/reset_ball_button
#@onready var level_up_text: Label = $Control/xp_bar/level_up_text

@onready var ball_ready: bool = false

# Init variables
@export var base_add: float = 1
@export var base_xp_gain: float = 1.0
@export var base_score: float = 0
@export var gems = 0
@export var stars = 500


var add: float = base_add
var xp_gain: float = base_xp_gain
var score: float = base_score
var gem_gain_multiplier: float = 5

func _init() -> void:
	# Randomise seed to start the game launching ball in random direction
	randomize()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await ball.ready
	xp_bar.initialise(ball.experience, ball.experience_required)
	score_label.text = str("Score: ", snapped(score, 0.01))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	score_label.text = str("Score: ", snapped(score, 0.01))
	gems_label.text = str("Gems: ", snapped(gems,0.01), " ")
	velocity_label.text = str("Current velocity: ", snapped(ball.velocity.length(), 0.01))

func _on_ball_bounce() -> void:
	ball.gain_experience(xp_gain)
	score += add


func _on_ball_levelled_up(level: int) -> void:
	score += 10 + pow(level, 2.2)
	gems += 1 + snapped (level, 10) * gem_gain_multiplier
	display_level_up_text()


func display_level_up_text() -> void:
	var level_up_text = preload("res://Scenes/level_up_text.tscn").instantiate()
	level_up_text.modulate.a = 0
	xp_bar.add_child(level_up_text)
	# Get center of xp_bar
	var xp_bar_center: Vector2 = xp_bar.global_position + xp_bar.get_rect().size * 0.5
	# Get center of level_up_text
	var level_up_text_center: Vector2 = level_up_text.get_rect().size * 0.5
	# Animate tween
	var target_position: Vector2 = Vector2(xp_bar_center.x - level_up_text_center.x, xp_bar.global_position.y - 50)
	var tw := get_tree().create_tween()
	tw.set_parallel()
	tw.tween_property(level_up_text, "modulate:a", 1, 0.2)
	tw.tween_property(level_up_text, "global_position", target_position, 0.4)
	#await tw.finished
	await get_tree().create_timer(0.45).timeout
	xp_bar.remove_child(level_up_text)
	
