class_name FireSlime extends Unit

var enemys_target_selector = EnemysTargetSelector.new() 

func _init():
	id = 2

func isTurn(battle_system: BattleSystem):
	var fireball = Fireball.new()
	fireball.battle_system = battle_system
	fireball.game_manager = battle_system.game_manager
	
	if (battle_system.active_character.currentHP <= maxHP * 0.1):
		var rng = RandomNumberGenerator.new()
		if (rng.randf_range(0, 1) < 0.2):
			battle_system.defend()
		else:
			await fireball.base_effect(battle_system.active_character, enemys_target_selector.choose_target(battle_system))
	else:
		await fireball.base_effect(battle_system.active_character, enemys_target_selector.choose_target(battle_system))
