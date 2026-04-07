class_name IceSlime extends Unit

var enemys_target_selector = EnemysTargetSelector.new() 

func _init():
	id = 3

func isTurn(battle_system: BattleSystem):
	var iceball = Iceball.new()
	iceball.battle_system = battle_system
	iceball.game_manager = battle_system.game_manager
	
	if (battle_system.active_character.currentHP <= maxHP * 0.1):
		var rng = RandomNumberGenerator.new()
		if (rng.randf_range(0, 1) < 0.2):
			battle_system.defend()
		else:
			await iceball.base_effect(battle_system.active_character, enemys_target_selector.choose_target(battle_system))
	else:
		await iceball.base_effect(battle_system.active_character, enemys_target_selector.choose_target(battle_system))
