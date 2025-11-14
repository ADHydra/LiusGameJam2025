extends CharacterBody2D
@export var SPEED = 300


func get_input():
	if Input.is_action_just_pressed("move_left"):
		velocity.x += SPEED
	if Input.is_action_just_pressed("move_left"):
		velocity.x -= SPEED
		
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
