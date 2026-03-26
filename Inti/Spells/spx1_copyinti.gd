class_name CopyInti extends Spell #planificalo bien luego, estas enfermo. con ganas de codear pero enfermo

func _init() -> void:
	pass

func base_effect(user: Node2D, objective: Node2D):
	if(battle_system.active_character.side):
		battle_system.active_character.currentSP -= cost
	
	if (!objective.side):
		var currentHP = objective.currentHP
		var maxHP = objective.maxHP
		var rng = RandomNumberGenerator.new()
		if (rng.randi_range(0, maxHP) > currentHP):
			pass #consigue el inti
		else:
			battle_system.add_message("¡Falló la copia!")
	else:
		await battle_system.add_message("¡No podés copiar el Inti de un compañero!")
		
	battle_system.turn_manager()

func boosted_effect(user: Node2D, objective: Node2D):
	if(battle_system.active_character.side):
		battle_system.active_character.currentSP -= cost
	
	if (!objective.side):
		pass
	else:
		await battle_system.add_message("¡No podés copiar el Inti de un compañero!")
	
	battle_system.turn_manager()
