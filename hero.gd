class_name Hero extends Battler

var nextXP

var maxSP
var currentSP

var spell_array: Array[Spell]

func initialize() -> void:
	if (id == 0):
		unit = game_manager.noelia_data #estas líneas hay que corregirlas luego
	else:
		unit = game_manager.ash_data
	
	side = true
	unit_name = unit.unit_name
	level = unit.level
	nextXP = unit.nextXP
	XP = unit.XP
	
	maxHP = unit.maxHP_w_e
	currentHP = unit.currentHP
	maxSP = unit.maxSP_w_e
	currentSP = maxSP
	agility = unit.agility_w_e #borra esto que es para prueba
	physical_strength = unit.physical_strength_w_e
	physical_defense = unit.physical_defense_w_e
	magical_strength = unit.magical_strength_w_e
	magical_defense = unit.magical_defense_w_e
	luck = unit.luck_w_e
	
	strong_against = unit.strong_against
	weak_against = unit.weak_against
	
	turns_for_altered_stats = [ 0, 0, 0]
	altered_stats = [false, false, false]
	altered_stats_icons = [$Status/BurntIcon, $Status/FrozenIcon, $Status/ShockedIcon]
	
	move_animation_speed = unit.move_animation_speed
	
	side = true
	is_alive = true
	spell_array = unit.spell_array
	
	status_bar.position = Vector2(0, 15)
	
	for i in spell_array.size(): #preparo cada clase con el battle_system para que sepan qué corno leer
		spell_array[i].battle_system = battle_system
		spell_array[i].game_manager = battle_system.game_manager

func die():
	currentHP = 0
	var i: int = 0
	var found: bool = false
	while (i < battle_system.turn_order_array.size() and !found):
		if(battle_system.turn_order_array[i] == self):
			battle_system.turn_order_array.remove_at(i)
			found = true
		i += 1
	battle_system.need_to_reset_cursor = true
	is_alive = false

func revive():
	is_alive = true
	battle_system.turn_order_array.append(self)

func update_character():
	if(is_alive):
		unit.XP = XP
		unit.currentHP = currentHP
		if (nextXP <= XP):
			_level_up()
	else:
		unit.currentHP = 1


func _level_up(): #codigo sin finalizar
	unit.level += 1
	unit.nextXP = nextXP
	unit.maxHP = maxHP 

	unit.agility = agility
	unit.physical_strength = physical_strength
	unit.physical_defense = physical_defense
	unit.magical_strength = magical_strength
	unit.magical_defense = magical_defense
	#when someone's XP is equal to their nextXP, the level goes up and you add up to each stat accordingly
