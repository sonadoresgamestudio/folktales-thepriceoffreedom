class_name Heal extends Spell

func _init():
	spell_name = "Heal"
	element = BattleSystem.Elements.HOLY
	for_allies = true
	cost = 2
	upgrade_cost = 6

func base_effect(user: Battler, objective: Battler):
	sfx = "spell_good_02_sfx"
	var heal_power = user.magical_strength * 0.4 #formula placeholder
	
	await battle_system.show_message(user.unit_name + " is healing " + objective.unit_name + "!")
	battle_system.audio_manager.load_sfx(sfx)
	battle_system.active_character.currentSP -= cost
	
	objective.currentHP += roundi(heal_power)
	if (objective.currentHP > objective.maxHP):
		objective.currentHP = objective.maxHP
	
	battle_system.update_ui()
	
	await battle_system.show_message(objective.unit_name + " feels better now!")
	
	battle_system.turn_manager()

func boosted_effect(user: Node2D, objective: Node2D):
	sfx = "spell_good_02_sfx"
	await battle_system.show_message(user.unit_name + " is fully healing " + objective.unit_name + "!")
	battle_system.audio_manager.load_sfx(sfx)
	battle_system.active_character.currentSP -= upgrade_cost
	
	objective.current_hp = objective.max_hp
	
	await battle_system.add_message(objective.unit_name + " feels perfectly fine now!")
	
	battle_system.turn_manager()
