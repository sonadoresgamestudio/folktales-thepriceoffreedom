class_name BattleCursor extends Node2D

var hero_cursor_spawn: Array[Node2D] #array de los lugares donde puede estar el cursor
var enemy_cursor_spawn: Array[Node2D]
var command_cursor_spawn: Array[Node2D]
var abilities_cursor_spawn: Array[Node2D]

var what_cursor_spawn: int #0 es command, 1 heroe, 2 enemigos, 3 hablilidades

var battle_system: BattleSystem
var command_menu: CommandMenu
var enemy_group_array: Array[Enemy]
var gamestate: BattleSystem.GameStates

@export var speed: int #esto es solo para el movimiento

func initialize():
	what_cursor_spawn = 0
	
	battle_system = get_parent()
	command_menu = battle_system.command_menu
	enemy_group_array = battle_system.enemy_group.array
	gamestate = battle_system.gamestate
	
	name = "Cursor"
	if(battle_system.noelia.is_alive):
		hero_cursor_spawn.append(battle_system.noelia)
	if(battle_system.ash.is_alive):
		hero_cursor_spawn.append(battle_system.ash)
	
	for i in enemy_group_array.size():
		enemy_cursor_spawn.append(enemy_group_array[i].get_node("Cursor Spawn"))
	
	command_cursor_spawn.append(command_menu.get_node("VBoxContainer/Attack Button/Cursor Spawn"))
	command_cursor_spawn.append(command_menu.get_node("VBoxContainer/Defend Button/Cursor Spawn"))
	command_cursor_spawn.append(command_menu.get_node("VBoxContainer/Abilities Button/Cursor Spawn"))
	#command_cursor_spawn.append(command_menu.get_node("Inventory Button/Cursor Spawn"))

func set_cursor_position(what_cursor_spawn: int, cursor_pos: int): #RECORDÁ ARREGLAR ESTO, POR ESO LO METI EN COMENTARIO
	match(what_cursor_spawn):
		0:
			if(command_cursor_spawn[cursor_pos] != null):
				global_position = command_cursor_spawn[cursor_pos].global_position
		1:
			if(hero_cursor_spawn[cursor_pos] != null):
				global_position = hero_cursor_spawn[cursor_pos].global_position
		2:
			if(enemy_cursor_spawn[cursor_pos] != null):
				global_position = enemy_cursor_spawn[cursor_pos].global_position
		3: 
			if(abilities_cursor_spawn[cursor_pos] != null):
				global_position = abilities_cursor_spawn[cursor_pos].global_position

func reset_fighters():
	hero_cursor_spawn.clear()
	enemy_cursor_spawn.clear()
	initialize()
