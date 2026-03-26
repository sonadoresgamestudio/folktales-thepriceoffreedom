class_name ArrayList extends Resource #JSOOOOOOOOOOOOON *con la voz de ethan de heavy rain

var enemy_array
var enemy_database_json: JSON = JSON.new()

func initialize(battle_system: BattleSystem, array_ordered: int):
	enemy_array = battle_system.enemy_array
	
	match(array_ordered):
		0:
			enemy_array.append(SkeletonKnight.new())
			enemy_array.append(SkeletonKnight.new())
		1:
			enemy_array.append(FireSlime.new())
			enemy_array.append(SkeletonKnight.new())
			enemy_array.append(FireSlime.new())
		2:
			enemy_array.append(IceSlime.new())
			enemy_array.append(SkeletonKnight.new())
			enemy_array.append(IceSlime.new())
		3:
			enemy_array.append(ThunderSlime.new())
			enemy_array.append(SkeletonKnight.new())
			enemy_array.append(ThunderSlime.new())
		4:
			enemy_array.append(FireSlime.new())
			enemy_array.append(ThunderSlime.new())
			enemy_array.append(IceSlime.new())
