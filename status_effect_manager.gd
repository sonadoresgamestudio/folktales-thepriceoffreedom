class_name StatusEffectManager extends Resource #chequea si hay que aplicar efectos antes de cada turno, despues del mismo y al realizar diversas acciones

var battle_system: BattleSystem
var gamestate: BattleSystem.GameStates
var gamestate_aux: BattleSystem.GameStates
#necesito tantas funciones o con tener un par que brancheen está? ("brancheen" del inglés "to branch")
#region BURNT
func is_burnt(burnt: Node2D):
	
	gamestate = battle_system.gamestate
	battle_system.gamestate = BattleSystem.GameStates.MESSAGE_SHOWN
	
	if(burnt.altered_stats[0]):
		await battle_system.show_message("¡Las quemaduras de " + burnt.unit_name + " se expanden!")
	else:
		await battle_system.show_message("¡" + burnt.unit_name + " sufre de quemaduras!")
		burnt.altered_stats[0] = true
		burnt.turns_for_altered_stats[0] = 0
	
	burnt.turns_for_altered_stats[0] += 3
	burnt.altered_stats_icons[0].visible = true
	battle_system.gamestate = gamestate

func is_still_burnt(stillBurnt: Node2D): #daño por turno
	gamestate = battle_system.gamestate
	battle_system.gamestate = BattleSystem.GameStates.MESSAGE_SHOWN
	
	battle_system.sfx_player.set_stream(load("res://sfx ( tambien re ordenar)/Spell Fire 02.wav"))
	battle_system.sfx_player.play(0)
	
	await battle_system.show_message(stillBurnt.unit_name + " siente las quemaduras arder...")
	
	var extra: float = 1
	
	if stillBurnt.weak_against[1]:
		extra = 1.5
	if stillBurnt.strong_against[1]:
		extra = 0.5
	
	var damage: int = roundi((stillBurnt.currentHP * 0.05) * extra)
	stillBurnt.currentHP -= damage 
	
	stillBurnt.turns_for_altered_stats[0] -= 1
	
	await battle_system.add_message("¡Ha recibido " + str(damage) + " de daño!")
	
	battle_system.gamestate = gamestate

func is_not_burnt(notBurnt: Node2D):
	gamestate = battle_system.gamestate
	battle_system.gamestate = BattleSystem.GameStates.MESSAGE_SHOWN
	
	await battle_system.show_message("¡" + notBurnt.unit_name + " siente que la quemazón se atenúa!")
	await battle_system.add_message("¡" + notBurnt.unit_name + " ya no está ardiendo!")
	notBurnt.altered_stats[0] = false
	notBurnt.altered_stats_icons[0].visible = false
	
	battle_system.gamestate = gamestate

#endregion

#region FROZEN
func is_frozen(frozen: Node2D):
	gamestate = battle_system.gamestate
	battle_system.gamestate = BattleSystem.GameStates.MESSAGE_SHOWN
	
	if (frozen.altered_stats[1]):
		await battle_system.show_message("¡" + frozen.unit_name + " ya está congelado!")
		await battle_system.add_message("¡El hielo en su cuerpo se expande por otros 3 turnos más!")
	else:
		await battle_system.show_message("¡" + frozen.unit_name + " siente su cuerpo congelarse!")
		await battle_system.add_message("El frío ralentiza sus movimientos y ataques por 3 turnos.")
		frozen.agility = roundi(frozen.agility/2)
		frozen.physical_strength = roundi(frozen.physical_strength/2)
		frozen.magical_strength = roundi(frozen.magical_strength/2)
		frozen.altered_stats[1] = true
		frozen.turns_for_altered_stats[1] = 0
	
	frozen.altered_stats_icons[1].visible = true
	frozen.turns_for_altered_stats[1] += 3
	battle_system.gamestate = gamestate

func is_still_frozen(stillFrozen: Node2D): #baja la defensa y el ataque? puede que sea bastante dos stats, tampoco necesitamos mil
	gamestate = battle_system.gamestate
	battle_system.gamestate = BattleSystem.GameStates.MESSAGE_SHOWN
	
	battle_system.sfx_player.set_stream(load("res://sfx ( tambien re ordenar)/Spell Ice.wav"))
	battle_system.sfx_player.play(0)
	
	await battle_system.show_message(stillFrozen.unit_name + " todavía siente su cuerpo congelado...")
	await battle_system.add_message("¡El frío sigue ralentizando sus movimientos y ataques!")
	
	stillFrozen.turns_for_altered_stats[1] -= 1
	battle_system.gamestate = gamestate

func is_not_frozen(notFrozen: Node2D):
	gamestate = battle_system.gamestate
	battle_system.gamestate = BattleSystem.GameStates.MESSAGE_SHOWN
	
	await battle_system.show_message("¡" + notFrozen.unit_name + " ya no siente frío!")
	await battle_system.add_message("¡Se siente mucho mejor!")
	
	notFrozen.altered_stats[1] = false
	
	if(notFrozen is Hero):
		notFrozen.agility = notFrozen.unit.agility_w_e
		notFrozen.physical_strength = notFrozen.unit.physical_strength_w_e
		notFrozen.magical_strength = notFrozen.unit.magical_strength_w_e
	else:
		notFrozen.agility = notFrozen.unit.agility
		notFrozen.physical_strength = notFrozen.unit.physical_strength
		notFrozen.magical_strength = notFrozen.unit.magical_strength
	
	notFrozen.altered_stats_icons[1].visible = false
	battle_system.gamestate = gamestate
#endregion

#region SHOCKED
func is_shocked(shocked: Node2D):
	gamestate = battle_system.gamestate
	battle_system.gamestate = BattleSystem.GameStates.MESSAGE_SHOWN
	
	if(shocked.altered_stats[2]):
		await battle_system.show_message("¡" + shocked.unit_name + " siente a la electricidad en su cuerpo intensificarse!")
		await battle_system.add_message("Va a persistir por 3 turnos más...")
		
	else:
		await battle_system.show_message("¡" + shocked.unit_name + " se encuentra electrificado!")
		await battle_system.add_message("Tal vez no pueda moverse en su próximo turno.")
		shocked.altered_stats[2] = true
		shocked.turns_for_altered_stats[2] = 0
	shocked.turns_for_altered_stats[2] += 3
	
	shocked.altered_stats_icons[2].visible = true
	
	battle_system.gamestate = gamestate


func is_still_shocked(stillShocked: Node2D) -> bool: #paraliza
	gamestate = battle_system.gamestate
	battle_system.gamestate = BattleSystem.GameStates.MESSAGE_SHOWN
	
	await battle_system.show_message(stillShocked.unit_name + " está electrificado...")
	await battle_system.add_message("¿Podrá moverse este turno?")
	var rng = RandomNumberGenerator.new()
	stillShocked.turns_for_altered_stats[2] -= 1
	
	battle_system.sfx_player.set_stream(load("res://sfx ( tambien re ordenar)/Spell Bad 02.wav"))
	battle_system.sfx_player.play(0)
	
	if (rng.randf() <= 0.4):
		await battle_system.show_message("¡" + stillShocked.unit_name + " es incapaz de moverse y ha perdido su turno!")
		battle_system.gamestate = gamestate
		return true
	else:
		await battle_system.show_message("¡" + stillShocked.unit_name + " puede actuar normalmente este turno!")
		battle_system.gamestate = gamestate
		return false

func is_not_shocked(notShocked: Node2D):
	gamestate = battle_system.gamestate
	battle_system.gamestate = BattleSystem.GameStates.MESSAGE_SHOWN
	
	await battle_system.show_message("¡" + notShocked.unit_name + " ya no siente corriente en su cuerpo!")
	await battle_system.add_message("¡Ya puede volver a luchar sin problemas!")
	
	notShocked.altered_stats[2] = false
	
	notShocked.altered_stats_icons[2].visible = false
	
	battle_system.gamestate = gamestate
#endregion 


func isSpedUp(spedup: Node2D): #acelera el stat agility
	pass

func isSpedDown(speddown: Node2D): #reduce el stat agility
	pass
