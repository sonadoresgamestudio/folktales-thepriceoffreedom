class_name Enemy extends Battler


func initialize():
	if (unit != null):
		await battle_system.initialize(unit)
		
		side = false 
		
		unit_name = unit.unit_name
		level = unit.level
		XP = unit.XP
		
		maxHP = unit.maxHP 
		currentHP = unit.currentHP
		agility = unit.agility
		physical_strength = unit.physical_strength
		physical_defense = unit.physical_defense
		magical_strength = unit.magical_strength
		magical_defense = unit.magical_defense
		spiritCharge = unit.spiritCharge
		luck = unit.luck
		
		strong_against = unit.strong_against
		weak_against = unit.weak_against
		
		turns_for_altered_stats = [ 0, 0, 0]
		altered_stats = [false, false, false]
		altered_stats_icons = [$Status/BurntIcon, $Status/FrozenIcon, $Status/ShockedIcon]
		
		side = unit.side
		
		sprite.texture = unit.texture
		
		status_bar.position = Vector2(0, 15)
	else:
		queue_free()
		
func die():
	var i: int = 0
	var found: bool = false
	while (i < battle_system.turn_order_array.size() and !found):
		if(battle_system.turn_order_array[i] == self):
			battle_system.turn_order_array.remove_at(i)
			found = true
		i += 1
	i = 0
	found = false
	
	while (i < battle_system.enemy_group.array.size() and !found):
		if(battle_system.enemy_group.array[i] == self):
			battle_system.enemy_group.array.remove_at(i)
			found = true
		i += 1
	
	
	battle_system.need_to_reset_cursor = true
	queue_free()
