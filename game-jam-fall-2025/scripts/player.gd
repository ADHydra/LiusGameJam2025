extends CharacterBody2D
@export var SPEED = 300
@export var crouch_speed = 100
const GRAVITY = 900
@export var jump_height = 400
var is_crouched = false
signal health_changed(amount)
var hp = 10

func take_damage(amount):
	hp-= amount
	hp = max(hp,0)
	emit_signal("health_changed",hp)
	
func get_input(delta):
	var input = Input.get_vector("move_left","move_right","move_up","move_down")

	# GRAVITY
	velocity.y += GRAVITY * delta

	# ---------- CROUCH LOGIC ----------
	if Input.is_action_pressed("move_down"):
		# Enter crouch
		if !is_crouched:
			is_crouched = true
			$normal_collision.disabled = true
			$crouch_collision.disabled = false
			$player_animation.play("crouch")

		# Crouch movement (NO run animation)
		velocity.x = input.x * crouch_speed

		# Flip depending on movement direction
		if input.x > 0:
			$player_animation.flip_h = false
		elif input.x < 0:
			$player_animation.flip_h = true

	else:
		# Exit crouch
		if is_crouched:
			is_crouched = false
			$normal_collision.disabled = false
			$crouch_collision.disabled = true

		# ----------- NORMAL MOVEMENT -----------
		velocity.x = input.x * SPEED

		# Play walking animation only when moving AND not crouched
		if input.x > 0:
			$player_animation.flip_h = false
			$player_animation.play("Run")
		elif input.x < 0:
			$player_animation.flip_h = true
			$player_animation.play("Run")
		else:
			$player_animation.play("idle")

	# ----------- JUMP -----------
	if is_on_floor() and Input.is_action_just_pressed("move_up"):
		velocity.y = -jump_height
		
func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()
