class_name Inti extends Resource

var index: String #para rastrear en el json
var inti_name: String
var lvl: int
var nextXP: int
var currentXP: int
var type: int # 01 spells, 02 equip, 03 automatic
var color: int #type of Inti, must coincide with number of types, red is 
var modifier: int #para alterar lo que sea, pero todos pueden tener modifier
var cost: int
var upgrade_cost: int
var battle_system: BattleSystem
var icon: Texture2D
