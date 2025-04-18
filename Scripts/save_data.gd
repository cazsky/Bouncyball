class_name SavedGame
extends Resource

# Game stats
@export var ball_position: Vector2
@export var score: float
@export var gems: float
@export var ball_velocity: float

# Ball stats
@export var speed_upgrade_level: int
@export var bounciness_upgrade_level: int
@export var friction_upgrade_level: int
@export var xp_upgrade_level: int
@export var score_upgrade_level: int

# Double stacks
@export var double_speed_stack: int
@export var double_bounce_stack: int
@export var double_xp_stack: int
@export var double_score_stack: int
@export var double_ball_stack: int

# Relics
@export var owned_relics: Array
