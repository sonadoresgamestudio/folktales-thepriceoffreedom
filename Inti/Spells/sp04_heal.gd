class_name Heal extends Spell

func _init():
	spell_name = "Heal"
	element = GameManager.Elements.HOLY
	for_allies = true
	cost = 2
	upgrade_cost = 6

func base_effect(user: Battler, objective: Battler):
	sfx = load(game_manager.load_file("spell_good_02_sfx"))
	var heal_power = user.magical_strength * 0.4 #formula placeholder
	
	await battle_system.show_message(user.unit_name + " is healing " + objective.unit_name + "!")
	battle_system.sfx_player.set_stream(sfx)
	battle_system.sfx_player.play()
	battle_system.active_character.currentSP -= cost
	
	objective.currentHP += roundi(heal_power)
	if (objective.currentHP > objective.maxHP):
		objective.currentHP = objective.maxHP
	
	battle_system.update_ui()
	
	await battle_system.show_message(objective.unit_name + " feels better now!")
	
	battle_system.turn_manager()

func boosted_effect(user: Node2D, objective: Node2D):
	sfx = load(game_manager.load_file("spell_good_02_sfx"))
	await battle_system.show_message(user.unit_name + " is fully healing " + objective.unit_name + "!")
	battle_system.sfx_player.set_stream(sfx)
	battle_system.sfx_player.play(0)
	battle_system.active_character.currentSP -= upgrade_cost
	
	objective.current_hp = objective.max_hp
	
	await battle_system.add_message(objective.unit_name + " feels perfectly fine now!")
	
	battle_system.turn_manager()
