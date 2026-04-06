class_name DamageCalculator extends Resource

var damage_counter: PackedScene

func process_damage(user: Battler, objective: Battler, user_agility: int, user_agility_aux: int, objective_agility: int, objective_agility_aux: int, attack: int, defense: int, is_upgraded: bool, extra: Callable, element: GameManager.Elements, is_spell: bool, sfx: String): #unificar los cálculos de daño acá
	var rng = RandomNumberGenerator.new()
	var activate_extra: bool = false
	#necesitamos animación/sfx para cuando arranca un ataque y para cuando este pega en el objetivo
	
	
	if (user_agility_aux <= objective_agility_aux): #"Denesting" aplicado
		print("The attack was dodged.")
		return
	
	
	var damage: int
	if (objective.side && objective.is_defending):
		damage = int((round(attack * rng.randf_range(1.2, 1.25)) - (defense/2 * rng.randf_range(1.1, 1.2)))) * 5
	else:
		damage = int(round(attack * rng.randf_range(1.2, 1.25)) - (defense * rng.randf_range(1.1, 1.2))) * 5
	damage *= apply_elemental_modifier(objective, damage, element)
	
	damage_counter = load("res://damage_counter.tscn").instantiate()
	damage_counter.damage = damage
	damage_counter.position = objective.position
	
	print(user.unit_name + " has done " + str(damage) + " points of damage to " + objective.unit_name + ".")
	if (damage <= 0):
		print("The attack has been blocked.")
	else:
		objective.currentHP -= damage #agregar otro sonido para cuando ataca
	#if (active_character.side and !is_inti):
		#active_character.currentSP = add_spirit_points(active_character.currentSP, active_character.spiritCharge, active_character.maxSP, active_character.unit_name)
	#else:
		#if (objective.side && objective.currentHP >= 0):
			#objective.currentSP = add_spirit_points(objective.currentSP, active_character.spiritCharge, objective.maxSP, objective.unit_name) #crear algo para decidir cuanto carga el spirit_points acá y no usar el defense charge
	if (objective.currentHP <= 0):
		if (objective.side):
			print(objective.unit_name + " has been knocked out...")
		else:
			print(user.unit_name + " has slained " + objective.unit_name + "!")	
		objective.die()
	else:
		if (is_upgraded):
			activate_extra = true
	
	if (activate_extra):
		await extra.call()
	
func apply_elemental_modifier(objective: Battler, damage: int, element: GameManager.Elements) -> int:
	
	for i in objective.strong_against.size():
		if(objective.strong_against[i] == element):
			return 0.75
	
	for i in objective.weak_against.size():
		if(objective.weak_against[i] == element):
			return 1.5
	return 1
