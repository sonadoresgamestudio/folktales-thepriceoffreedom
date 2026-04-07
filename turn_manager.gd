class_name TurnManager extends Resource

func turn_manager():
	gamestate = GameStates.SORTING
	
	
	if (!party_member_1.is_alive and !party_member_2.is_alive):
		await _battleLost()
		return
	
	if (enemy_group.array.size() == 0):
		await _battleWon()
		return
	
	if(need_to_reset_cursor):
		cursor.reset_fighters()
		need_to_reset_cursor = false
	
	
	var i: int = 0
	
	while turn_order_array[i].counter_to_turns > 0:
		if (turn_order_array[i].is_alive):
			#print(turn_order_array[i].unit_name + " tiene un contador de " + str(turn_order_array[i].counter_to_turns) + " unidades.")
			turn_order_array[i].counter_to_turns -= 1
		i+=1
		if i == turn_order_array.size():
			i = 0
	
	for j in turn_order_array.size():
		if(turn_order_array[j].counter_to_turns == 0):
			active_character = turn_order_array[j]
			break
	
	active_character.counter_to_turns = 100
	
	if(active_character is Hero):
		animated_sprite = active_character.get_node("AnimatedSprite2D")
	
	await check_ailments()

func turn_sorter():#al menos que haya bugs, esta función debería estar finalizada
	var aux
	for i in turn_order_array.size():
		var pos = i
		while (pos > 0) and (turn_order_array[pos-1].agility < turn_order_array[pos].agility):
			aux = turn_order_array[pos]
			turn_order_array[pos] = turn_order_array[pos-1]
			turn_order_array[pos-1] = aux
			pos -= 1
	for i in turn_order_array.size():
		var pos = i
		var rng = RandomNumberGenerator.new()
		while (pos > 0) and (turn_order_array[pos-1].agility == turn_order_array[pos].agility):
			if(rng.randf_range(turn_order_array[pos-1].luck, turn_order_array[pos].luck) >= turn_order_array[pos].luck):
				aux = turn_order_array[pos]
				turn_order_array[pos] = turn_order_array[pos-1]
				turn_order_array[pos-1] = aux
			pos -= 1 #luck is rigged, chequear luego porque un pos = 1 con igual velocidad a un pos = 4 puede que nunca lleguen a ser comparados, las chances no son las del RNG

#repasar el turn sorter para entender cómo carajo opera, era el método burbuja esto?
