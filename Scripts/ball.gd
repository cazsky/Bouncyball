extends CharacterBody2D

@export var speed: float = 600.0 

@warning_ignore("unused_signal")
signal bounce

func _ready() -> void:
	velocity = Vector2(speed, speed)


func _physics_process(delta: float) -> void:
	if get_last_slide_collision():
		var collision: KinematicCollision2D = get_last_slide_collision()
		velocity = velocity.bounce(collision.get_normal())
		# Connect signal to main game to add score whenever ball bounces
		emit_signal("bounce")
		
	move_and_slide()
