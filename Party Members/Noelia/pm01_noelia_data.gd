class_name NoeliaData extends Unit

var lvl: int
var nextXP: int
var is_in_party: bool
var spell_array: Array[Spell] #el equivalente nuestro a la materia de ff7, "inti" es un nombre placeholder

var maxHP_w_e: int 
var agility_w_e: int
var physical_strength_w_e: int
var physical_defense_w_e: int
var magical_strength_w_e: int
var magical_defense_w_e: int
var luck_w_e: int
var maxSP_w_e: int
var spiritCharge_w_e: int

func _init():
	
	maxHP = 100
	currentHP = maxHP
	physical_strength = 14
	physical_defense = 13
	magical_strength = 13
	magical_defense = 12
	agility = 8
	spiritCharge = 4
	maxSP = 20
	
	move_animation_speed = 500
	
	id = 0
	unit_name = "Noelia"
	lvl = 1
	is_in_party = true
	maxHP_w_e = maxHP
	agility_w_e = agility
	physical_strength_w_e = physical_strength
	physical_defense_w_e = physical_defense
	magical_strength_w_e = magical_strength
	magical_defense_w_e = magical_defense
	luck_w_e = luck
	maxSP_w_e = maxSP
	spiritCharge_w_e = spiritCharge
	
	
	#hechizos hardcodeados para el prototipo
	spell_array.append(HolyStrike.new())
	spell_array.append(Heal.new())
	
func limit_break():
	pass
