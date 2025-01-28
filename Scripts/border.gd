extends StaticBody2D

""" This script is used to dynamically change the thickness of the borders as 
	the ball can escape from the borders if velocity is too high. 
	The thickness will increase as the velocity increases."""

@onready var top_border: CollisionShape2D = $TopBorder
@onready var bottom_border: CollisionShape2D = $BottomBorder
@onready var left_border: CollisionShape2D = $LeftBorder
@onready var right_border: CollisionShape2D = $RightBorder
@onready var ball: CharacterBody2D = $"../Ball"

# Thickness of 30px needed velocity.length of roughly 5.7mil to break
# 5.7mil/30 = 19000 
const DIFFERENCE: float = 19000

var horizontal_rect := RectangleShape2D.new()
var vertical_rect := RectangleShape2D.new()
var width: float = 720
var height: float = 1180
var thickness: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# This formula caps at 700mil
	thickness = snapped(ball.current_speed/DIFFERENCE,10) + 30
	set_horizontal_border()
	set_vertical_border()
	
func set_horizontal_border() -> void:
	horizontal_rect.size = Vector2(width + thickness*2, thickness)
	top_border.shape = horizontal_rect
	top_border.global_position = Vector2(width/2, -thickness/2)
	bottom_border.shape = horizontal_rect
	bottom_border.global_position = Vector2(width/2, height + thickness/2)
	
func set_vertical_border() -> void:
	vertical_rect.size = Vector2(thickness, height)
	right_border.shape = vertical_rect
	right_border.global_position = Vector2(width + thickness/2, height/2)
	left_border.shape = vertical_rect
	left_border.global_position = Vector2(-thickness/2, height/2)
	

func _on_menu_velocity_changed(current_speed: float) -> void:
	thickness = snapped(current_speed/DIFFERENCE,10) + 30
	print_debug(thickness)
	set_horizontal_border()
	print_debug(horizontal_rect.size)
	set_vertical_border()
