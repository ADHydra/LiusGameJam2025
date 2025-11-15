extends Node2D
@onready var bar = $ProgressBar
@export var player : CharacterBody2D
var hp = 10



func _ready():
	player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(value):
	bar.value = value
