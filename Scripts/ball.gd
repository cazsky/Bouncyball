extends CharacterBody2D

@export var base_speed: float = 400.0
# Friction above 1 makes it stickier, closer to 0 means less sticky
# Dont go to negative friction
@export var base_friction: float = 2.0
@export var level: int = 1


@onready var velocity_stat_label: Label = $"../Control/Stats/Velocity"
@onready var menu: Node2D = $"../Menu"
@onready var game: Node2D = $"../"

var experience: float = 0
var experience_total: float = 0
var experience_required: int = get_required_expereience(level + 1)

var friction: float = base_friction
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
@warning_ignore("unused_signal")
signal levelled_up(level)



func _ready() -> void:
	# Generate a random direction
	# TAU is 2PI, gives a random angle in radians
	# Use TAU for a full 360 degrees
	var angle = randf() * TAU 
	# cos(angle) gives the distance along the x-axis and sin(angle) for y-axis
	direction = Vector2(cos(angle), sin(angle)).normalized()
	velocity = direction * current_speed
	
	print_debug(global_position)
	
	
	make_trail()


func _physics_process(delta: float) -> void:

	detect_bounce()
	move_and_slide()
	
	# Apply friction while the ball has added speed from bounce
	if velocity.length() > current_speed:
		# Check notes for difference
		#velocity *= pow(damping, delta * 60 * friction)
		velocity = velocity.normalized() * lerp(velocity.length(), current_speed, delta * friction)
		
	# Ensure velocity at least base_speed
	if velocity.length() < base_speed:
		velocity = velocity.normalized() * base_speed
		



		

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
	emit_signal("levelled_up", level)
	
func update_stats() -> void:
	current_speed = base_speed * menu.speed_mult * pow(2, menu.double_speed_stack)
	velocity = velocity.normalized() * base_speed * menu.speed_mult * pow(2, menu.double_speed_stack)
	menu.bounciness = menu.BASE_BOUNCINESS * menu.bounce_mult * pow(2, menu.double_bounce_stack)
	friction = base_friction * menu.friction_mult
	game.xp_gain = game.base_xp_gain * menu.xp_mult * pow(2, menu.double_xp_stack)
	game.add = game.base_add * menu.score_mult * pow(2, menu.double_score_stack)
	
func check_ball_in_bounds() -> bool:
	print_debug("OOB Check: ", global_position)
	if 0 > global_position.x and global_position.x < 720:
		if 0 > global_position.y and global_position.y < 1280:
			return true
	return false


func _on_oob_timer_timeout() -> void:
	if !check_ball_in_bounds():
		global_position = get_viewport().get_visible_rect().size / 2
