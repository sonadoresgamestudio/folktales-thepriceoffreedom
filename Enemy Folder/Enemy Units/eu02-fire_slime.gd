class_name FireSlime extends Unit

var base_enemy_skill = BaseEnemySkill.new()
var enemy_skills: Array[BaseEnemySkill]
var has_inti_to_give: bool = true

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
			await fireball.base_effect(battle_system.active_character, base_enemy_skill.choose_target(battle_system))
	else:
		await fireball.base_effect(battle_system.active_character, base_enemy_skill.choose_target(battle_system))
