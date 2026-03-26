class_name SkeletonKnight extends Unit

var base_enemy_skill = BaseEnemySkill.new()
var enemy_skills: Array[BaseEnemySkill]
var has_inti_to_give: bool = true

func _init():
	id = 1

func isTurn(battle_system: BattleSystem):
	if (battle_system.active_character.currentHP <= maxHP * 0.1):
		var rng = RandomNumberGenerator.new()
		if (rng.randf_range(0, 1) < 0.2):
			battle_system.defend()
		else:
			battle_system.physical_attack(base_enemy_skill.choose_target(battle_system))
	else:
		battle_system.physical_attack(base_enemy_skill.choose_target(battle_system))
