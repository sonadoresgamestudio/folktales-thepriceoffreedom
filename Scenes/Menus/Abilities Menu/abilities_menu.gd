class_name AbilitiesMenu extends PanelContainer

var inti_array: Array[Inti]
var cost_arrays: Array[Vector2i] #x = costo base, y = costo upgrade
var ability: Ability
var ability_array: Array[Ability]
@onready var v_box: VBoxContainer = $VBoxContainer
@onready var upgrade: Label = $Upgrade

func initialize(active_fighter: Hero, battle_system: BattleSystem):
	inti_array = active_fighter.inti_array
	for i in inti_array.size():
		if (inti_array[i] is Spell):
			ability = load("res://Scenes/Menus/Abilities Menu/ability_scene.tscn").instantiate() #chequear esto para cuando volvés para atrás y luego para adelante
			ability.ability_name.text = inti_array[i].inti_name
			ability.action = Callable(inti_array[i], "is_selected")
			ability.for_allies = inti_array[i].for_allies
			ability.cost = inti_array[i].cost
			ability.upgrade_cost = inti_array[i].upgrade_cost
			ability.cost_label.text = str(ability.cost)
			ability.upgrade_cost_label.text = str(ability.upgrade_cost)
			ability_array.append(ability)
			cost_arrays.append(Vector2i(ability.cost, ability.upgrade_cost))
			battle_system.cursor.abilities_cursor_spawn.append(ability.cursor_spawn)
			v_box.add_child(ability)

func reset_menu(battle_system: BattleSystem):
	var children_nodes = v_box.get_children()
	while children_nodes.size() > 0:
		children_nodes[children_nodes.size()-1].queue_free()
		children_nodes.remove_at(children_nodes.size()-1)
	battle_system.cursor.abilities_cursor_spawn.clear()
