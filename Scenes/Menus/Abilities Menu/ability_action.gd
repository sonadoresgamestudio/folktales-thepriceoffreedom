class_name Ability extends HBoxContainer

var action: Callable
var for_allies: bool
var cost: int
var upgrade_cost: int
@export var ability_name: Label
@export var cost_label: Label
@export var upgrade_cost_label: Label
@export var cursor_spawn: Node2D

func _ready() -> void:
	cursor_spawn.position = self.position - Vector2(25, -9)
