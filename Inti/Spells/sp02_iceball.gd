class_name Iceball extends Spell

func _init():
	spell_name = "Iceball"
	element = BattleSystem.Elements.ICE
	for_allies = false
	cost = 3
	upgrade_cost = 6


func base_effect(user: Battler, objective: Battler):
	sfx = "spell_ice_sfx"
	if battle_system.active_character.side:
		battle_system.gamestate = battle_system.GameStates.ACTION
	else:
		battle_system.gamestate = battle_system.GameStates.ENEMY
	var attack: int = user.magical_strength
	var defense: int = objective.magical_defense
	var attacker_agility: int = user.agility
	var defender_agility: int = objective.agility
	var rng = RandomNumberGenerator.new()
	var attacker_agility_aux = rng.randf_range(1, 1.30)
	var defender_agility_aux = rng.randf_range(0.90, 1.20)
	
	await battle_system.show_message(user.unit_name + " has cast an " + spell_name + " against " + objective.unit_name)
	
	if(battle_system.active_character.side):
		battle_system.active_character.currentSP -= cost
	
	await battle_system.process_damage(objective, attacker_agility, attacker_agility_aux, defender_agility, defender_agility_aux, attack, defense, false, Callable(), element, true, sfx)
	
	battle_system.turn_manager()

func boosted_effect(user: Battler, objective: Battler):
	sfx = "spell_ice_sfx"
	if battle_system.active_character.side:
		battle_system.gamestate = battle_system.GameStates.ACTION
	else:
		battle_system.gamestate = battle_system.GameStates.ENEMY
	var attack: int = user.magical_strength
	var defense: int = objective.magical_defense
	var attacker_agility: int = user.agility
	var defender_agility: int = objective.agility
	var rng = RandomNumberGenerator.new()
	var attacker_agility_aux = rng.randf_range(1, 1.30)
	var defender_agility_aux = rng.randf_range(0.70, 1)
	
	
	await battle_system.show_message(user.unit_name + " has cast an upgraded " + spell_name + " against " + objective.unit_name)
	
	if(battle_system.active_character.side):
		battle_system.active_character.currentSP -= upgrade_cost
	
	await battle_system.process_damage(objective, attacker_agility, attacker_agility_aux, defender_agility, defender_agility_aux, attack, defense, true, Callable(battle_system.status_effect_manager, "is_frozen").bind(objective), element, true, sfx)
	
	battle_system.turn_manager()
