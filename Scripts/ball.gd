extends CharacterBody2D

@export var base_speed: float = 350.0
# Friction above 1 makes it stickier, closer to 0 means less sticky
# Dont go to negative friction
@export var friction: float = 2.0

@onready var velocity_stat_label: Label = $"../Control/Stats/Velocity"

@export var level: int = 1


var experience: float = 0
var experience_total: float = 0
var experience_required: int = get_required_expereience(level + 1)

var current_speed = base_speed
var current_trail: Trail
var can_push: bool = true
var damping: float = 0.98
var direction: Vector2
var inverse_friction: float = 0 

@warning_ignore("unused_signal")
signal bounce
@warning_ignore("unused_signal")
signal experience_gained(growth_data)

func _ready() -> void:
	# Generate a random direction
	# TAU is 2PI, gives a random angle in radians
	# Use TAU for a full 360 degrees
	var angle = randf() * TAU 
	# cos(angle) gives the distance along the x-axis and sin(angle) for y-axis
	direction = Vector2(cos(angle), sin(angle)).normalized()
	velocity = direction * current_speed

	make_trail()


func _physics_process(delta: float) -> void:

	detect_bounce()
	move_and_slide()
	
	# Apply friction while the ball has added speed from bounce
	if velocity.length() > current_speed:
		# Check notes for difference
		#velocity *= pow(damping, delta * 60 * friction)
		velocity = velocity.normalized() * lerp(velocity.length(), current_speed, delta * friction)
		
	# Cant set to minimum 0 or the ball will just stop i guess
	#velocity = velocity.clampf(-10000, current_speed)

	# Stop movement when velocity is near zero
	if velocity.length() < 10:
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

func get_required_expereience(lvl: int) -> int:
	return round(pow(lvl, 1.8) + lvl * 4 + 10)

func gain_experience(amount: float) -> void:
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required, experience_required])
		level_up()
	growth_data.append([experience, experience_required])
	emit_signal("experience_gained", growth_data)
		
func level_up() -> void:
	level += 1
	experience_required = get_required_expereience(level + 1)
	
