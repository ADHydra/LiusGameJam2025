extends Node2D
@export var player : CharacterBody2D
@export var segul: Node2D
@export var healthbar:Node2D
@export var camera_on_player: Camera2D
@export var camera_static: Camera2D

func start_pickup_animation():
	player.can_move = false
	healthbar.hide()
	player.velocity = Vector2.ZERO
	
	segul.get_node("AnimatedSprite2D").play("fly")
	
	var tween = create_tween()
	#--- SEAGULL FLYS IN TO SCENE --- #
	tween.tween_property(segul,"global_position",player.global_position,2)
	tween.parallel().tween_property(camera_static,"global_position",player.global_position,2)
	await tween.finished
	
	
	# --- CREATE THE ANIMATION THAT PICKS UP THE TURTLE--- #
	tween = create_tween()
	tween.tween_property(segul,"global_position",global_position + Vector2(-player.global_position.x,-1000),2.0)
	tween.parallel().tween_property(player,"global_position",global_position + Vector2(-player.global_position.x,-1000),2.0)
	
	await tween.finished
	
	
	
	
	
	
	
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_pickup_animation()
		
