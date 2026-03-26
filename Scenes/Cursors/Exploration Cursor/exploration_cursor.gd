class_name ExplorationCursor extends Node2D

var node_cursor_spawn: Array[Node2D] #el cursor spawn de cada nodo al que se puede ir

var exploration_system: ExplorationSystem
var gamestate: ExplorationSystem.GameStates

# Called when the node enters the scene tree for the first time.
func initialize():
	exploration_system = get_parent()
	gamestate = exploration_system.gamestate
	
	name = "Cursor"
	
	for i in exploration_system.connected_nodes.size():
		node_cursor_spawn.append(exploration_system.connected_nodes[i].get_node("Cursor Spawn"))
	

func set_cursor_position(cursor_pos: int):
	if(node_cursor_spawn[cursor_pos] != null):
		global_position = node_cursor_spawn[cursor_pos].global_position
		
func reset_nodes():
	node_cursor_spawn.clear()
	initialize()
