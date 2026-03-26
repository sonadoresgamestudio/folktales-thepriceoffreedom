class_name Spell extends Inti

var element: GameManager.Elements
var for_allies: bool #qué "side", party members o enemigos? true es party memeber, false es enemigo
var effect: AnimatedSprite2D
var sfx : AudioStream
var range : int #rango al que le podés dar al objetivo

func is_selected(target: Node2D):
	
	var is_upgraded: bool = battle_system.is_upgrading
	
	if (is_upgraded):
		await boosted_effect(battle_system.active_character, target)
	else:
		await base_effect(battle_system.active_character, target)

func base_effect(user: Battler, objective: Battler):
	pass
	
func boosted_effect(user: Battler, objective: Battler):
	pass
