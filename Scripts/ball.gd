extends CharacterBody2D

@export var speed: float = 600.0 

var current_trail: Trail

@warning_ignore("unused_signal")
signal bounce

func _ready() -> void:
	# Generate a random direction
	# TAU is 2PI, gives a random angle in radians
	# Use TAU for a full 360 degrees
	var angle = randf() * TAU 
	# cos(angle) gives the distance along the x-axis and sin(angle) for y-axis
	var direction = Vector2(cos(angle), sin(angle)).normalized()
	velocity = direction * speed
	
	make_trail()


func _physics_process(delta: float) -> void:
	
	detect_bounce()
	move_and_slide()


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


func _on_button_pressed() -> void:
	pass # Replace with function body.
