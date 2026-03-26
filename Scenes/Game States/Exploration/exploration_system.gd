class_name ExplorationSystem extends Node

@onready var game_manager: GameManager = get_parent()
#@onready var player_manager: PlayerManager = get_node("Player")
@onready var current_map: Node2D = get_node("Prototype Map")

var inventory: Dictionary

@export var exploration_text: ExplorationText

var cursor: ExplorationCursor

enum GameStates{START, SEARCH, TALK, BATTLE, ROOM_CHANGE, SYSTEM, END} #SEARCH es cuando estamos con el mouse mirando la habitación, TALK cuando se muestra algún diálogo, ROOM_CHANGE para cuando cambie de habitación (por si las moscas), SYSTEM es mensajes del juego al jugador, END... ya veremos
var gamestate: GameStates = GameStates.START

signal accept

func _ready() -> void:
	gamestate = GameStates.SEARCH
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	match(gamestate):
		GameStates.START:
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()
		GameStates.SEARCH:
			if (Input.is_action_just_pressed("confirm") or Input.is_action_just_pressed("left_click")):
				accept.emit()
		GameStates.TALK:
			if (Input.is_action_just_pressed("confirm") or Input.is_action_just_pressed("left_click")):
				accept.emit()
		GameStates.BATTLE:
			pass
		GameStates.ROOM_CHANGE:
			pass
		GameStates.SYSTEM:
			if (Input.is_action_just_pressed("confirm")):
				accept.emit()
		GameStates.END:
			pass
#
#func load_map():
	#pass #cuando haya más mapas usaremos esta función para decidir qué cargar
func show_message(speaker: Texture, s_name: String, message: String):
	if (gamestate == GameStates.SEARCH):
		gamestate = GameStates.TALK
		exploration_text.visible = true
		exploration_text.speaker.texture = speaker
		exploration_text.s_name.text = s_name
		exploration_text.message.text = message
		await accept
		exploration_text.visible = false
		gamestate = GameStates.SEARCH


func add_message(speaker: Texture, s_name: String, message: String):
	if (gamestate == GameStates.SEARCH):
		gamestate = GameStates.TALK
		exploration_text.visible = true
		exploration_text.speaker.texture = speaker
		exploration_text.s_name.text = s_name
		exploration_text.message.text += ("\n" + message)
		await accept
		exploration_text.visible = false
		gamestate = GameStates.SEARCH
