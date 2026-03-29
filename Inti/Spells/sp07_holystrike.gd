class_name HolyStrike extends Spell

func _init():
	spell_name = "Holy Strike"
	element = GameManager.Elements.HOLY
	for_allies = false
	cost = 3
	upgrade_cost = 6


func base_effect(user: Battler, objective: Battler):
	sfx = load(game_manager.load_file("spell_good_01_sfx"))
	if battle_system.active_character.side:
		battle_system.gamestate = battle_system.GameStates.ACTION
	else:
		battle_system.gamestate = battle_system.GameStates.ENEMY
	var attack: int = (user.magical_strength + user.physical_strength)/2
	var defense: int = (objective.magical_defense + user.physical_defense)/2
	var attacker_agility: int = user.agility
	var defender_agility: int = objective.agility
	var rng = RandomNumberGenerator.new()
	var attacker_agility_aux = rng.randf_range(1, 1.30)
	var defender_agility_aux = rng.randf_range(0.90, 1.20)
	
	
	await battle_system.show_message(user.unit_name + " has cast a " + spell_name + " against " + objective.unit_name)
	
	if(battle_system.active_character.side):
		battle_system.active_character.currentSP -= cost
	
	await battle_system.process_damage(objective, attacker_agility, attacker_agility_aux, defender_agility, defender_agility_aux, attack, defense, false, Callable(), 1, true, sfx)
	
	battle_system.turn_manager()


func boosted_effect(user: Battler, objective: Battler):
	sfx = load(game_manager.load_file("spell_good_01_sfx"))
	if battle_system.active_character.side:
		battle_system.gamestate = battle_system.GameStates.ACTION
	else:
		battle_system.gamestate = battle_system.GameStates.ENEMY
	var attack: int = 2*(user.magical_strength + user.physical_strength)/3
	var defense: int = 2*(objective.magical_defense + user.physical_defense)/3
	var attacker_agility: int = user.agility
	var defender_agility: int = objective.agility
	var rng = RandomNumberGenerator.new()
	var attacker_agility_aux = rng.randf_range(1, 1.30)
	var defender_agility_aux = rng.randf_range(0.70, 1)
	
	
	await battle_system.show_message(user.unit_name + " has cast an upgraded " + spell_name + " against " + objective.unit_name)
	
	if(battle_system.active_character.side):
		battle_system.active_character.currentSP -= upgrade_cost
	
	await battle_system.process_damage(objective, attacker_agility, attacker_agility_aux, defender_agility, defender_agility_aux, attack, defense, true, Callable(battle_system.status_effect_manager, "is_burnt").bind(objective), 1, true, sfx)
	
	battle_system.turn_manager()
