extends SavedGame
class_name SavedPerkData

# Speed perk
@export var double_speed_stack: int = 0
@export var double_speed_price: int = 200
@export var double_speed_time: int = 5
@export var double_speed_time_left: float = 0
@export var double_speed_is_active: bool

# XP perk
@export var double_xp_stack: int = 0
@export var double_xp_price: int = 500
@export var double_xp_time: int = 30
@export var double_xp_time_left: float = 0
@export var double_xp_is_active: bool

# Bounce perk
@export var double_bounce_stack: int = 0
@export var double_bounce_price: int = 1000
@export var double_bounce_time: int = 30
@export var double_bounce_time_left: float = 0
@export var double_bounce_is_active: bool

# Score perk
@export var double_score_stack: int = 0
@export var double_score_price: int = 2000
@export var double_score_time: int = 30
@export var double_score_time_left: float = 0
@export var double_score_is_active: bool

# Ball perk
@export var double_ball_stack: int = 0
@export var double_ball_price: int = 5000
@export var double_ball_time: int = 30
@export var double_ball_time_left: int = 0
@export var double_ball_is_active: bool
