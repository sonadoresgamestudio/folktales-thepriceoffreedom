class_name InteractiveObject extends Area2D

var first_time: bool = true
@export var exploration_system: ExplorationSystem
@onready var game_manager: GameManager = exploration_system.get_parent()
@export var map: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(0,0)
	$CollisionShape2D.scale = scale
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
