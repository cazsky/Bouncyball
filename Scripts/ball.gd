extends CharacterBody2D

@export var base_speed: float = 700.0
# Friction above 1 makes it stickier, closer to 0 means less sticky
# Dont go to negative friction
@export var friction: float = 1.0

@onready var speed_stat_label: Label = $"../Control/Stats/Speed"
@onready var velocity_stat_label: Label = $"../Control/Stats/Velocity"

var current_speed = base_speed
var current_trail: Trail
var is_moving: bool = false
var can_push: bool = true
var damping: float = 0.98

@warning_ignore("unused_signal")
signal bounce

func _ready() -> void:
	# Set initial velocity to ZERO so the ball doesnt move
	velocity = Vector2.ZERO
	make_trail()


func _physics_process(delta: float) -> void:
	print_debug("???")
	if is_moving:
		detect_bounce()
		move_and_slide()
		
		# Gradually reduce velocity to simulate deceleration
		# Frame rate independant damping
		velocity *= pow(damping, delta * 60 * friction)
		# Cant set to 0 or the ball will just stop i guess
		velocity = velocity.clampf(-10000, current_speed)

		# Stop movement when velocity is near zero
		if velocity.length() < 10:
			is_moving = false
			velocity = Vector2.ZERO
			

func make_trail() -> void:
	if current_trail:
		current_trail.stop()
	current_trail = Trail.create()
	add_child(current_trail)
	
func detect_bounce() -> void:
	if get_last_slide_collision():
		var collision: KinematicCollision2D = get_last_slide_collision()
		velocity = velocity.bounce(collision.get_normal())
		# Connect signal to main game to add score whenever ball bounces
		emit_signal("bounce")

# We want for the ball to move a certain distance whenever the screen is tapped.
func _on_button_pressed() -> void:
	# Generate a random direction
	# TAU is 2PI, gives a random angle in radians
	# Use TAU for a full 360 degrees
	var angle = randf() * TAU 
	# cos(angle) gives the distance along the x-axis and sin(angle) for y-axis
	var direction = Vector2(cos(angle), sin(angle)).normalized()
	velocity = direction * current_speed
	is_moving = true

	
