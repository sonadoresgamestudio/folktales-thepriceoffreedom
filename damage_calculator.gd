class_name DamageCalculator extends Resource

var damage_counter: PackedScene

signal result(int)

func process_damage(user: Battler, objective: Battler, user_agility: int, user_agility_aux: int, objective_agility: int, objective_agility_aux: int, attack: int, defense: int, is_upgraded: bool, extra: Callable, element: BattleSystem.Elements, is_spell: bool, sfx: String): #unificar los cálculos de daño acá
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
	
	
	print(user.unit_name + " has done " + str(damage) + " points of damage to " + objective.unit_name + ".")
	if (damage <= 0):
		print("The attack has been blocked.")
	else:
		objective.currentHP -= damage #agregar otro sonido para cuando ataca
	
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
	
func apply_elemental_modifier(objective: Battler, damage: int, element: BattleSystem.Elements) -> int:
	
	for i in objective.strong_against.size():
		if(objective.strong_against[i] == element):
			return 0.75
	
	for i in objective.weak_against.size():
		if(objective.weak_against[i] == element):
			return 1.5
	return 1
