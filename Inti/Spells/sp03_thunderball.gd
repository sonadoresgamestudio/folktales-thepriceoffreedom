class_name Thunderball extends Spell

func _init():
	inti_name = "Bola de Trueno"
	element = GameManager.Elements.THUNDER
	for_allies = false
	cost = 3
	upgrade_cost = 6
	sfx = load("res://sfx ( tambien re ordenar)/Spell Bad 02.wav")

func base_effect(user: Battler, objective: Battler):
	if battle_system.active_character.side:
		battle_system.gamestate = battle_system.GameStates.ACTION
	else:
		battle_system.gamestate = battle_system.GameStates.ENEMY
	var attack: int = user.magical_strength
	var defense: int = objective.magical_defense
	var attacker_agility: int = user.agility
	var defender_agility: int = objective.agility
	var rng = RandomNumberGenerator.new()
	var attacker_agility_aux = rng.randf_range(attacker_agility, attacker_agility * 1.30)
	var defender_agility_aux = rng.randf_range(defender_agility * 0.70, defender_agility)
	var sfx = load("res://sfx ( tambien re ordenar)/Spell Bad 01.wav")
	
	
	await battle_system.show_message(user.unit_name + " ha lanzado una " + inti_name + " a " + objective.unit_name)
	
	if(battle_system.active_character.side):
		battle_system.active_character.currentSP -= cost
	
	await battle_system.process_damage(objective, attacker_agility, attacker_agility_aux, defender_agility, defender_agility_aux, attack, defense, false, Callable(), 3, true, sfx)
	
	battle_system.turn_manager()
	
func boosted_effect(user: Battler, objective: Battler):
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
	var sfx = load("res://sfx ( tambien re ordenar)/Spell Bad 01.wav")
	
	await battle_system.show_message(user.unit_name + " ha lanzado una " + inti_name + " mejorada a " + objective.unit_name)
	
	if(battle_system.active_character.side):
		battle_system.active_character.currentSP -= upgrade_cost
	
	await battle_system.process_damage(objective, attacker_agility, attacker_agility_aux, defender_agility, defender_agility_aux, attack, defense, true, Callable(battle_system.status_effect_manager, "is_shocked").bind(objective), 3, true, sfx)
	
	battle_system.turn_manager()
