extends CharacterBody2D

@export var SPEED = 300
@export var crouch_speed = 100
@export var jump_height = 400
@export var segul: PackedScene
const GRAVITY = 900

var is_crouched = false
var is_on_glass_bottle = false
var can_move = true




	
	
func is_touching_glass_bottle() -> bool:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("jump_bug"):
			return true
	return false

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

	var jump_bug = is_touching_glass_bottle()
	# ----------- JUMP -----------
	if (is_on_floor() or jump_bug) and Input.is_action_just_pressed("move_up"):
		velocity.y = -jump_height
		
	# ---------- SOUND -----------
	if (input.x != 0 or input.y != 0) and !$WalkingStream.playing and is_on_floor():
		$WalkingStream.play()
	if input.y < 0 and !$JumpSound.playing:
		$JumpSound.play()
		
		
		
func _physics_process(delta: float) -> void:
	if can_move == true:
			get_input(delta)
			move_and_slide()
	
	
