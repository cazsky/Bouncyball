class_name SavedGame
extends Resource

# Game stats
@export var ball_position: Vector2
@export var score: float
@export var gems: float

# Ball stats
@export var speed_upgrade_level: float
@export var bounciness_upgrade_level: float
@export var friction_upgrade_level: float
@export var xp_upgrade_level: float
@export var score_upgrade_level: float

# Double stacks
@export var double_speed_stack: int
@export var double_bounce_stack: int
@export var double_xp_stack: int
@export var double_score_stack: int
@export var double_ball_stack: int
