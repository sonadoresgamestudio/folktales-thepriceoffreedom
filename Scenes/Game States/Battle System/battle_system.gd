class_name BattleSystem extends Node #se tendría que aplicar un botón para decidir cuánto spirit points gastar y ver cómo modifica esto cada outcome pero eso es DESPUES del prototipo

#region declarando variables
@onready var game_manager: GameManager = get_parent()
@onready var exploration_system: ExplorationSystem = game_manager.get_node("Exploration System")
@onready var music_player: AudioStreamPlayer = $"Audio Manager/Music Player"
@onready var sfx_player: AudioStreamPlayer = $"Audio Manager/SFX Player"
@export var background_music: Array[AudioStream]
@onready var UI: CanvasLayer = $UI

@export var noelia: Hero
@export var noeliaHpLabel: Label
@export var noeliaSpLabel: Label

@export var ash: Hero
@export var ashHpLabel: Label
@export var ashSpLabel: Label

@export var omar: Hero
@export var omarHpLabel: Label
@export var omarSpLabel: Label
#tener en cuenta el posible #guestcharacter

var hero_array: Array[Hero]
var h_size: int
var active_character: Battler #vamos a usar los party member y enemy acá

var animated_sprite: AnimatedSprite2D

#@export var _dungeon_manager: DungeonManager

@export var enemy_group: EnemyGroup #esta variable hace referencia al nodo dentro de la escena del battle system

var enemy_array: Array[Unit] #esta variable hace referencia al RESOURCE del cual se cargan los enemigos
var e_size: int

var added_xp: int #placeholder para el xp que conseguís de los bichos derrotados

@export var battle_info: Label

#var _level: int

enum GameStates { START, PLAYER_TURN, SORTING, CHOOSE_TARGET, CHOOSE_ABILITY, MOVEMENT, ACTION, ENEMY, WON, LOST, MESSAGE_SHOWN } #0 battle start/enemy turn (no control), 1 player turn, 2 choose target, 3 executed action
var gamestate: GameStates = GameStates.START

var command_menu: CommandMenu#cambiá todas las referencias y métodos de button a control (nodo más genérico)
var abilities_menu: AbilitiesMenu
var status_effect_manager: StatusEffectManager

var turn_order_array: Array 

var for_allies: bool
var cursor: BattleCursor #la manito/flechita que indica sobre qué opción está el jugador
var target_position: Vector2
var damage_counter: DamageCounter
@export var turn_order_panel: TurnOrderPanel

var command_cursor_pos: int 
var ability_cursor_pos: int
var target_cursor_pos: int

var is_upgrading: bool #hacerlo una función que no solo cambie la variable, si no la visibilidad entre otras cosas
var need_to_reset_cursor: bool

signal accept
#endregion
func _ready():
	
	exploration_system.queue_free()
	music_player.set_stream(background_music[0])
	music_player.play(0)
	
	#region inicializando party members
	#chequear si están los party members necesarios
	noelia.unit = game_manager.noelia_data
	ash.unit = game_manager.ash_data
	noelia.initialize()
	ash.initialize()
	#_level = _dungeon_manager.level
	
	var _noeliaagility = noelia.agility
	var _noeliaagilityaux = noelia.agility
	
	var _ashagility = ash.agility
	var _ashagilityaux = ash.agility
	
	
	if (noelia != null): # tener un #guestcharacter
		hero_array.append(noelia)
	if (ash != null):
		hero_array.append(ash)
	
	h_size = hero_array.size()
	
	for i in h_size:
		turn_order_array.append(hero_array[i])
	#endregion
	
	#region inicializando enemigos
	var rng = RandomNumberGenerator.new()
	var array_list = ArrayList.new() #la clase con los array de enemigos posibles
	array_list.initialize(self, rng.randi_range(0,4)) #se inicializa el cargar el array enemigo, cambiar el mínimo a 0 post expo
	e_size = enemy_array.size()
	
	for i in e_size:
		enemy_group.array[i].unit = enemy_array[i]
	for i in enemy_group.array.size():
		enemy_group.array[i].initialize()
	
	enemy_group.array.resize(e_size)
	
	for i in e_size:
		turn_order_array.append(enemy_group.array[i])
	#enemy_group.set_positions() ACA HAY COMENTARIO
	#endregion
	#region ordenando turnos
	for i in turn_order_array.size():
		turn_order_array[i].counter_to_turns = 100
	turn_sorter()
	#endregion
	
	#region iniciando menues
	var file_path = game_manager.load_file("command_menu_scene")
	command_menu = load(file_path).instantiate()
	command_menu.hide()
	add_child(command_menu)
	
	file_path = game_manager.load_file("battle_cursor_scene")
	cursor = load(file_path).instantiate()
	cursor.hide()
	add_child(cursor)
	cursor.initialize()
	
	file_path = game_manager.load_file("abilities_menu_scene")
	abilities_menu = load(file_path).instantiate()
	
	abilities_menu.hide()
	add_child(abilities_menu)
	#endregion
	
	status_effect_manager = StatusEffectManager.new()
	status_effect_manager.battle_system = self
	
	
	await show_message("Enemies have appeared!")

	
	turn_manager()

func _process(_delta: float) -> void: #desglosar en input() y process()
	update_ui()
	
	#if (Input.is_action_just_pressed("resetti")):
		#get_parent().load_battle()
		#queue_free()
	match(gamestate):
		GameStates.START:
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()
		GameStates.SORTING:
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()
		GameStates.PLAYER_TURN: 
			if (Input.is_action_just_pressed("up")):
				if (command_cursor_pos == 0):
					command_cursor_pos = cursor.command_cursor_spawn.size() - 1 #debe haber un problema donde haya que sacar la variable cursor de la funcion en la que esta, pero "cursor" ya está declarado como del tipo "Cursor" con mayúsucla que tiene el array command_... ni idea
				else: 
					command_cursor_pos = command_cursor_pos - 1
			if Input.is_action_just_pressed("down"):
				if (command_cursor_pos == cursor.command_cursor_spawn.size() - 1):
					command_cursor_pos = 0
				else: 
					command_cursor_pos = command_cursor_pos + 1
			if(cursor != null):
				cursor.set_cursor_position(0, command_cursor_pos)
			if (Input.is_action_just_pressed("confirm")):
				cursor.command_cursor_spawn[command_cursor_pos].get_parent().action.call()
		GameStates.CHOOSE_TARGET: #hay un error cuando querés dar vuelta el for allies
			if (Input.is_action_just_pressed("up") || Input.is_action_just_pressed("down")):
				for_allies = !for_allies
				target_cursor_pos = 0
				if (for_allies):
					cursor.set_cursor_position(1, target_cursor_pos)
				else:
					cursor.set_cursor_position(2, target_cursor_pos)
			if (Input.is_action_just_pressed("left")):
				if(for_allies):
					if(target_cursor_pos == 0):
						target_cursor_pos = cursor.hero_cursor_spawn.size() - 1
					else:
						target_cursor_pos -= 1
				else:
					if(target_cursor_pos == 0):
						target_cursor_pos = cursor.enemy_cursor_spawn.size() - 1
					else:
						target_cursor_pos -= 1
			if (Input.is_action_just_pressed("right")):
				if(for_allies):
					if(target_cursor_pos == cursor.hero_cursor_spawn.size() - 1):
						target_cursor_pos = 0
					else:
						target_cursor_pos += 1
				else:
					if(target_cursor_pos == cursor.enemy_cursor_spawn.size() - 1):
						target_cursor_pos = 0
					else:
						target_cursor_pos += 1
			if (cursor != null):
				if (for_allies):
					cursor.set_cursor_position(1, target_cursor_pos)
				else:
					cursor.set_cursor_position(2, target_cursor_pos)
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()
			if (Input.is_action_just_pressed("cancel")):
				active_turn()
		GameStates.CHOOSE_ABILITY:
			if (Input.is_action_just_pressed("up")):
				is_upgrading = false
				abilities_menu.upgrade.visible = false
				if (ability_cursor_pos == 0):
					ability_cursor_pos = cursor.abilities_cursor_spawn.size() - 1 #debe haber un problema donde haya que sacar la variable cursor de la funcion en la que esta, pero "cursor" ya está declarado como del tipo "Cursor" con mayúsucla que tiene el array command_... ni idea
				else: 
					ability_cursor_pos = ability_cursor_pos - 1
			if (Input.is_action_just_pressed("down")):
				is_upgrading = false
				abilities_menu.upgrade.visible = false
				if (ability_cursor_pos == cursor.abilities_cursor_spawn.size() - 1):
					ability_cursor_pos = 0
				else: 
					ability_cursor_pos = ability_cursor_pos + 1
			if ((Input.is_action_just_pressed("left")) or (Input.is_action_just_pressed("right"))):
				is_upgrading = !is_upgrading
				abilities_menu.upgrade.visible = !abilities_menu.upgrade.visible
			if(cursor != null):
				cursor.set_cursor_position(3, ability_cursor_pos)
			if (Input.is_action_just_pressed("confirm")):
				if(is_upgrading):
					if (cursor.abilities_cursor_spawn[ability_cursor_pos].get_parent().upgrade_cost <= active_character.currentSP):
						choose_target(cursor.abilities_cursor_spawn[ability_cursor_pos].get_parent().action, cursor.abilities_cursor_spawn[ability_cursor_pos].get_parent().for_allies)
						abilities_menu.hide()
						abilities_menu.reset_menu(self)
					else:
						var text_aux = battle_info.text 
						gamestate = GameStates.MESSAGE_SHOWN
						abilities_menu.hide()
						cursor.hide()
						await show_message("Not enough Spirit Points!")
						cursor.show()
						abilities_menu.show()
						gamestate = GameStates.CHOOSE_ABILITY
						battle_info.text = text_aux
				else:
					if (cursor.abilities_cursor_spawn[ability_cursor_pos].get_parent().cost <= active_character.currentSP):
						choose_target(cursor.abilities_cursor_spawn[ability_cursor_pos].get_parent().action, cursor.abilities_cursor_spawn[ability_cursor_pos].get_parent().for_allies) #chequear cómo hacer para que tome el upgrade
						abilities_menu.hide()
						abilities_menu.reset_menu(self)
					else:
						var text_aux = battle_info.text 
						gamestate = GameStates.MESSAGE_SHOWN
						abilities_menu.hide()
						await show_message("Not enough Spirit Points!")
						abilities_menu.show()
						gamestate = GameStates.CHOOSE_ABILITY
						battle_info.text = text_aux
			if (Input.is_action_just_pressed("cancel")):
				is_upgrading = false
				abilities_menu.upgrade.visible = false
				gamestate = GameStates.PLAYER_TURN
				abilities_menu.hide()
				cursor.hide()
				active_turn()
		GameStates.ACTION:
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()
				cursor.set_cursor_position(0, 0) #por qué esto acá especificamente y no cuando reinicia el turno o cuanndo quiero volver atras?
		GameStates.ENEMY:
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()
		GameStates.WON:
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()
		GameStates.LOST:
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()
		GameStates.MESSAGE_SHOWN:
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()

#region set who's turn it is
func turn_manager():
	gamestate = GameStates.SORTING
	
	
	if (!noelia.is_alive and !ash.is_alive):
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

func check_ailments(): #es para chquear si el personaje está quemado y coso
	
	await show_message("It's " + active_character.unit_name + "'s turn.")
	
	for i in active_character.altered_stats.size(): 
		if active_character.altered_stats[i]:
			match(i): #convertir esto en un loop para un array de callables PROTOTIPO
				0:
					if (active_character.turns_for_altered_stats[0] == 0):
						await status_effect_manager.is_not_burnt(active_character)
					else:
						await status_effect_manager.is_still_burnt(active_character)
				1:
					if (active_character.turns_for_altered_stats[1] == 0):
						await status_effect_manager.is_not_frozen(active_character)
					else:
						await status_effect_manager.is_still_frozen(active_character)
				2:
					if (active_character.turns_for_altered_stats[2] == 0):
						await status_effect_manager.is_not_shocked(active_character)
					else:
						if(await status_effect_manager.is_still_shocked(active_character)):
							await turn_manager()
	
	
	if (active_character.side):
		await active_turn()
	else:
		await active_character.unit.isTurn(self)
		
func active_turn():
	
	if active_character.side:
		gamestate = GameStates.PLAYER_TURN
	else:
		gamestate = GameStates.ENEMY
	
	battle_info.text = ("What is " + active_character.unit_name + " going to do?")
	command_cursor_pos = 0
	
	command_menu.show()
	await command_menu.initialize(self)
	cursor.show()
	
	active_character.is_defending = false

#endregion

func movement(): #como implementar en el resto de las acciones como codigo generico
	var tween = create_tween() 
	var distance = target_position.x - active_character.position.x
	var duration = abs(distance) / active_character.move_animation_speed
	if (distance < 0):
		animated_sprite.flip_h = false
	if (distance > 0):
		animated_sprite.flip_h = true
	tween.tween_callback(animated_sprite.play.bind("move"))
	tween.tween_property(active_character, "position", target_position, duration)
	tween.tween_callback(animated_sprite.play.bind("idle"))

func choose_target(ActionChosen: Callable, is_for_allies: bool): #adaptalo al estilo de los personajes, cambiale el nombre a for_allies y que el for allies dentro de la función sea la variable de clase a partir de la cual se maneja todo
	gamestate = GameStates.CHOOSE_TARGET
	battle_info.text = ("Choose a target.")
	
	if (is_for_allies):
		for_allies = true
		if (noelia.is_alive):
			target_cursor_pos = 0
		else:
			target_cursor_pos = 1
	else:
		for_allies = false
		target_cursor_pos = 0
	
	command_menu.hide()
	
	await accept
	
	if(gamestate == GameStates.CHOOSE_TARGET): #es un control por si habíamos presionado para volver atrás, siendo que choose target sigue "andando" técnicamente y esperando el "accept"
		
		cursor.hide()
		
		if (active_character.side):
			gamestate = GameStates.ACTION
			
		if (for_allies):
			await ActionChosen.call(hero_array[target_cursor_pos])
		else:
			await ActionChosen.call(enemy_group.array[target_cursor_pos])
		

func choose_ability():
	gamestate = GameStates.CHOOSE_ABILITY
	is_upgrading = false
	battle_info.text = ("What ability will " + active_character.unit_name + " use?")
	abilities_menu.reset_menu(self)
	ability_cursor_pos = 0
	abilities_menu.show()
	
	await abilities_menu.initialize(active_character, self)
	
	command_menu.hide()

func choose_inventory():
	await show_message("Te falta programar esto, amigo!")
	active_turn()

func add_spirit_points(currentSP:int, addedSP: int, maxSP:int, userName: String) -> int: #no hay balance alguno en cuanto a las variables relacionadas con spirit_points #spirit_points
	currentSP += addedSP
	if (currentSP > maxSP):
		currentSP = maxSP
	show_message(userName + " ha aumentado sus puntos de espíritu!") #cuál es el mensaje acá?
	return currentSP

func physical_attack(defender: Battler): 
	
	var attack: int = active_character.physical_strength
	var defense: int = defender.physical_defense
	var _active_character_agility: int = active_character.agility
	var defender_agility: int = defender.agility
	var rng = RandomNumberGenerator.new()
	var _active_character_agility_aux = rng.randf_range(_active_character_agility * 0.90, _active_character_agility * 1.20)
	var defender_agility_aux = rng.randf_range(defender_agility * 0.5, defender_agility * 0.75)#this is the result of the attack, no need to make a statement for a one-use variable
	var sfx
	
	if (gamestate == GameStates.ACTION):
		sfx = load("res://sfx ( tambien re ordenar)/Sword 01.wav")
	else:
		sfx = load("res://sfx ( tambien re ordenar)/Spell Bad 01.wav")
	
	await show_message(active_character.unit_name + " ha atacado a " + defender.unit_name)
	
	await process_damage(defender, _active_character_agility, _active_character_agility_aux, defender_agility, defender_agility_aux, attack, defense, false, Callable(), 5, false, sfx)
	
	turn_manager()

func check_elemental_modifier(objective: Battler, damage: int, element: GameManager.Elements) -> int:
	
	for i in objective.strong_against.size():
		if(objective.strong_against[i] == element):
			return damage * 0.75
	
	for i in objective.weak_against.size():
		if(objective.weak_against[i] == element):
			return damage * 1.5
	return damage

func defend():
	active_character.is_defending = true
	command_menu.hide()
	cursor.hide()
	turn_manager()

func _battleWon():
	gamestate = GameStates.WON
	music_player.set_stream(background_music[1])
	music_player.play(0)
	
	if (noelia.is_alive):
		noelia.update_character()
	if (ash.is_alive):
		ash.update_character()
	await show_message("You've won!")
	await add_message("Refresh the page to play again.")
	exploration_system.show()
	exploration_system.gamestate = exploration_system.GameStates.SEARCH #esto tiene que ser modificado post-prototipo
	queue_free()

func _battleLost():
	gamestate = GameStates.LOST
	music_player.set_stream(background_music[3])
	music_player.play(0)
	
	await show_message("Noelia and Ash have fallen..")
	await add_message("You've lost")
	await add_message("Refresh the page to start over.")

func show_message(message: String):
	battle_info.text = message
	await accept

func add_message(message: String):
	battle_info.text += ("\n" + message)
	await accept

func update_ui(): #re ver donde ubicar realmente esta funcion
	noeliaHpLabel.text = ("Health Points: " + str(noelia.currentHP) + "/" + str(noelia.maxHP))
	noeliaSpLabel.text = ("Spirit Points: " + str(noelia.currentSP) + "/" + str(noelia.maxSP))
	
	ashHpLabel.text = ("Health Points: " + str(ash.currentHP) + "/" + str(ash.maxHP))
	ashSpLabel.text = ("Spirit Points: " + str(ash.currentSP) + "/" + str(ash.maxSP))

func _on_music_player_finished() -> void:
	if (music_player.stream == load("res://musica (tambien reordenar)/Victory (intro).ogg")):
		music_player.set_stream(load("res://musica (tambien reordenar)/Victory (loop).ogg"))
		music_player.play(0)

func process_damage(objective: Battler, user_agility: int, user_agility_aux: int, objective_agility: int, objective_agility_aux: int, attack: int, defense: int, is_upgraded: bool, extra: Callable, element: int, is_inti: bool, sfx1: AudioStream): #unificar los cálculos de daño acá
	var rng = RandomNumberGenerator.new()
	var activate_extra: bool = false
	#necesitamos animación/sfx para cuando arranca un ataque y para cuando este pega en el objetivo
	if ((user_agility * user_agility_aux) > (objective_agility * objective_agility_aux)):
		var damage: int
		sfx_player.set_stream(sfx1)
		sfx_player.play(0)
		if (objective.side && objective.is_defending):
			damage = int((round(attack * rng.randf_range(1.2, 1.25)) - (defense/2 * rng.randf_range(1.1, 1.2)))) * 5
		else:
			damage = int(round(attack * rng.randf_range(1.2, 1.25)) - (defense * rng.randf_range(1.1, 1.2))) * 5
		damage = check_elemental_modifier(objective, damage, element)
		#damage_counter = DamageCounter.new()
		#damage_counter.damage = damage
		#add_child(damage_counter)
		#damage_counter.position = objective.position
		await show_message(active_character.unit_name + " has done" + str(damage) + " of damage to " + objective.unit_name + ".")
		if (damage <= 0):
			sfx_player.set_stream(load("res://sfx ( tambien re ordenar)/Shield 02.wav"))
			sfx_player.play(0)
			await show_message("The attack has been blocked.")
		else:
			objective.currentHP -= damage #agregar otro sonido para cuando ataca
		#if (active_character.side and !is_inti):
			#active_character.currentSP = add_spirit_points(active_character.currentSP, active_character.spiritCharge, active_character.maxSP, active_character.unit_name)
		#else:
			#if (objective.side && objective.currentHP >= 0):
				#objective.currentSP = add_spirit_points(objective.currentSP, active_character.spiritCharge, objective.maxSP, objective.unit_name) #crear algo para decidir cuanto carga el spirit_points acá y no usar el defense charge
		if (objective.currentHP <= 0):
			if (objective.side):
				await show_message(objective.unit_name + " has been knocked out...")
			else:
				await show_message(active_character.unit_name + " has slained" + objective.unit_name + "!")	
			objective.die()
		else:
			if (is_upgraded):
				activate_extra = true
	else:
		await show_message("The attack was dodged.")
	
	if (activate_extra):
		await extra.call()

func initialize(enemy: Unit): #inicializa enemigos, no el sistema de batalla
	enemy.strong_against.clear()
	enemy.weak_against.clear() #limpiar ambos cuando se optimice todo con el json
	
	var enemy_database = game_manager.load_json_data("enemy_database")
	var template = enemy_database[str(enemy.id)].duplicate()
	
	enemy.unit_name = template["unit_name"]
	enemy.XP = template["XP"]#modificar, obvio
	enemy.maxHP = template["maxHP"]
	enemy.currentHP = enemy.maxHP
	enemy.agility = template["agility"]
	enemy.physical_strength = template["phy_str"]
	enemy.physical_defense = template["phy_def"]
	enemy.magical_strength = template["mag_str"]
	enemy.magical_defense = template["mag_def"]
	enemy.luck = template["luck"]
	enemy.side = false
	var aux_array = template["strong"]
	for i in aux_array.size():
		enemy.strong_against.append(aux_array[i])
	aux_array.clear()
	aux_array = template["weak"]
	for i in aux_array.size():
		enemy.weak_against.append(aux_array[i])
	var aux_texture: String = template["texture"]
	enemy.texture = load(game_manager.load_file(aux_texture))
