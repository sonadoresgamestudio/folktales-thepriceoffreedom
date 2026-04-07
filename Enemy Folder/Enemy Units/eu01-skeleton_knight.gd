class_name SkeletonKnight extends Unit

var enemys_target_selector = EnemysTargetSelector.new() 

func _init():
	id = 1

func isTurn(battle_system: BattleSystem):
	if (battle_system.active_character.currentHP <= maxHP * 0.1):
		var rng = RandomNumberGenerator.new()
		if (rng.randf_range(0, 1) < 0.2):
			battle_system.defend()
		else:
			battle_system.physical_attack(enemys_target_selector.choose_target(battle_system))
	else:
		battle_system.physical_attack(enemys_target_selector.choose_target(battle_system))
