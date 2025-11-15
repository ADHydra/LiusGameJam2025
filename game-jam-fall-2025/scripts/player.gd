extends CharacterBody2D
@export var SPEED = 300
const GRAVITY = 900

func get_input():
	var input = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity.x = input.x * SPEED
	
func _physics_process(delta: float) -> void:
	get_input()
	if Input.is_action_just_pressed("move_right"):
		$player_animation.flip_h = false 
		$player_animation.play("Run")
	if Input.is_action_just_pressed("move_left"):
		$player_animation.flip_h = true
		$player_animation.play("Run")
	
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if Input.is_action_just_pressed("move_up"):
			velocity.y -= SPEED
	move_and_slide()
