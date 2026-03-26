class_name BattleNode extends MapNode

func run_node_function():
	label.text = "Hora de la BATTALLA"
	await game_manager.load_battle()
