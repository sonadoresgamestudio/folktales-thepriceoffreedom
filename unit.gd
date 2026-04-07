class_name Unit extends Resource

var id: int
var keyword: String
var unit_name: String
var level: int
var XP: int

var maxHP: int 
var currentHP: int
var agility: int
var physical_strength: int
var physical_defense: int
var magical_strength: int
var magical_defense: int
var luck: int
var spiritCharge: int
var maxSP: int

var side: bool
var strong_against: Array[BattleSystem.Elements] = []#crear listado de elementos, o debería hacer un listado de BOOLS
var weak_against: Array[BattleSystem.Elements] = []#crear listado de elementos, o debería hacer un listado de BOOLS
var texture: Texture2D
var move_animation_speed: int 


# 0 is none, 1 is fire, 2 is ice, 3 is thunder, 4 is holy, 5 physical
