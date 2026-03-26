class_name Heal extends Spell

func _init():
	inti_name = "Curación"
	element = GameManager.Elements.HOLY
	for_allies = true
	cost = 2
	upgrade_cost = 6
	sfx = load("res://sfx ( tambien re ordenar)/Spell Good 02.wav")

func base_effect(user: Battler, objective: Battler):
	var heal_power = user.magical_strength * 0.4 #formula placeholder
	
	await battle_system.show_message("¡" + user.unit_name + " está curando a " + objective.unit_name + "!")
	battle_system.sfx_player.set_stream(sfx)
	battle_system.play(0)
	battle_system.active_character.currentBoost -= cost
	
	objective.currentHP += roundi(heal_power)
	if (objective.currentHP > objective.maxHP):
		objective.currentHP = objective.maxHP
	
	battle_system.update_ui()
	
	await battle_system.show_message("¡" + objective.unit_name + " se siente mejor ahora!")
	
	battle_system.turn_manager()

func boosted_effect(user: Node2D, objective: Node2D):
	
	await battle_system.show_message("¡" + user.unit_name + " está curando a " + objective.unit_name + " por completo!")
	battle_system.sfx_player.set_stream(sfx)
	battle_system.play(0)
	battle_system.active_character.currentBoost -= upgrade_cost
	
	objective.current_hp = objective.max_hp
	
	await battle_system.add_message("¡" + objective.unit_name + " se siente en perfectas condiciones ahora!")
	
	battle_system.turn_manager()
