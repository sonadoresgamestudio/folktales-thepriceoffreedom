class_name InteractiveObject extends Area2D

@export var exploration_system: ExplorationSystem
@onready var game_manager: GameManager = exploration_system.get_parent()
@export var map: Node2D
@onready var object_hinter: ObjectHinter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(0,0)
	$CollisionShape2D.scale = scale
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if(event.is_action("show_objects")):
		var file_path = game_manager.load_file("object_hinter")
		object_hinter = load(file_path).instantiate()
		
	if(event.is_action_released("show_objects")):
		pass
