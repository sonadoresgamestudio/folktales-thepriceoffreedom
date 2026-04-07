class_name Battler extends CharacterBody2D

@export var battle_system: BattleSystem
@onready var game_manager: GameManager = battle_system.get_parent()
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

var spiritCharge: int
var luck: int
var side: bool
var is_alive = true

var counter_to_turns: int

var unit: Unit
var strong_against: Array[BattleSystem.Elements]
var weak_against: Array[BattleSystem.Elements]
var turns_for_altered_stats: Array[int] #dado un valor cualquier n, este representa la cantidad de turnos restantes para sufrir un ailment, es decir, si vale "3", en los próximos 3 turnos sufrirá dicho ailment y el número irá descendiendo hasta que llegue a 0 y pueda ser considerado "curado"
var altered_stats: Array[bool]
var altered_stats_icons: Array[TextureRect]
var move_animation_speed: int

var is_defending: bool
var is_turn: bool

@onready var status_bar = $Status 

@onready var sprite: Sprite2D = $Sprite2D
@export var id: int

var animation_library: AnimationLibrary
