class_name CommandMenu extends PanelContainer

@onready var attack: ButtonAction = get_node("VBoxContainer/Attack Button")
@onready var defend: ButtonAction = get_node("VBoxContainer/Defend Button")
@onready var abilities: ButtonAction = get_node("VBoxContainer/Abilities Button")
@onready var inventory: ButtonAction = get_node("VBoxContainer/Inventory Button")

# Called when the node enters the scene tree for the first time.
func _ready():
	name = "Command Menu"

func initialize(battle_system: BattleSystem):
	
	attack.action = Callable(battle_system, "choose_target").bind(Callable(battle_system, "physical_attack"), false)
	defend.action = Callable(battle_system, "defend")
	abilities.action = Callable(battle_system, "choose_ability")
	inventory.action = Callable(battle_system, "choose_item")
