class_name Delay extends Spell

func _init():
	spell_name = "Delay"
	element = 0
	for_allies = false
	cost = 4
	upgrade_cost = 6


func base_effect(user: Battler, objective: Battler):
	
	battle_system.active_character.currentBoost -= cost
	battle_system.turn_manager()


func boosted_effect(user: Battler, objective: Battler):
	battle_system.turn_manager()
