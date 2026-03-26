class_name EnemyGroup extends Node
#motivo del doc, spawnear los enemigos
@onready var enemy01: Enemy = get_node("Enemy 1")
@onready var enemy02: Enemy = get_node("Enemy 2")
@onready var enemy03: Enemy = get_node("Enemy 3")
@onready var enemy04: Enemy = get_node("Enemy 4")
@onready var enemy05: Enemy = get_node("Enemy 5")
@onready var enemy06: Enemy = get_node("Enemy 6")
@onready var array: Array[Enemy] = [enemy01, enemy02, enemy03, enemy04, enemy05, enemy06]

func set_positions():
	for i in array.size():
		array[i].position = Vector2(((i+1)*1920)/(array.size()+1), 2*1080/5)
