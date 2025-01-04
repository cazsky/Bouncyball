extends CharacterBody2D

@export var SPEED: float = 600.0


func _ready() -> void:
	velocity = Vector2(SPEED, SPEED)


func _physics_process(delta: float) -> void:
	if get_last_slide_collision():
		var collision: KinematicCollision2D = get_last_slide_collision()
		velocity = velocity.bounce(collision.get_normal())

	move_and_slide()
