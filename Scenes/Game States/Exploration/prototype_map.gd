class_name PrototypeMap extends Node2D

@onready var exploration_system: ExplorationSystem = get_parent()
@onready var room_1: Node2D = get_node("Room 1")
@onready var room_2: Node2D = get_node("Room 2")
@onready var go_to: Button = exploration_system.get_node("UI/Go To Button")
var steps: int #para saber el punto de la historia
var box_has_key: bool = false
var has_seen_door: bool = false
var has_key: bool = false #todas estas variables estan para el orto y son spaghetti code CAMBIAR
var door_is_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_go_to_button_pressed() -> void:
	if(exploration_system.gamestate == exploration_system.GameStates.SEARCH):
		if (room_1.visible):
			go_to.text = "Go to CELL"
		if (room_2.visible):
			go_to.text = "Go to DOOR"
		room_1.visible = !room_1.visible
		room_2.visible = !room_2.visible
		exploration_system.exploration_text.visible = false
