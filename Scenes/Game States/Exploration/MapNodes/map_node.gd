class_name MapNode extends Area2D

@export var id: int #para que el programador identifique el nodo específico por si las moscas
@onready var exploration_system: ExplorationSystem = get_parent().get_parent() #corregí línea
@onready var game_manager: GameManager = exploration_system.get_parent()
@export var connected_nodes: Array[MapNode] #nodos a los que podés ir desde acá, no tendremos variables para los nodos anteriores por ahora
@onready var icon: Sprite2D = $Sprite2D #van a ser placeholders por ahora
@export var label: Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func run_node_function():
	exploration_system.choose_node()
