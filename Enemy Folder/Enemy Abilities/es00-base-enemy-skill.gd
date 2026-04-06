class_name BaseEnemySkill extends Resource

func choose_target(battle_system: BattleSystem) -> Node2D:
	var noelia
	var ash
	noelia = battle_system.party_member_1
	ash = battle_system.party_member_2
	if (noelia.is_alive and ash.is_alive):
		var rng
		rng = RandomNumberGenerator.new()
		if (noelia.currentHP > ash.currentHP):
			if (rng.randf_range(0, 1) < 0.75):
				return noelia
			else:
				return ash
		else:
			if (rng.randf_range(0, 1) < 0.75):
				return ash
			else:
				return noelia
	else:
		if (noelia.is_alive):
			return noelia
		else:
			return ash
