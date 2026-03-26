class_name MainMenu extends Node

@onready var music_player: AudioStreamPlayer = $"Audio Manager/Music Player"
@onready var sfx_player: AudioStreamPlayer = $"Audio Manager/SFX Player"
var background_music
var sfx
@onready var game_manager: GameManager = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_player.stream =  load("res://musica (tambien reordenar)/Title Theme.ogg")
	music_player.play(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match(game_manager.gamestate): #no me gusta tener el match acá, prefiero que no tenga "process" propio
		game_manager.GameStates.MAINMENU:
			if (Input.is_action_just_pressed("confirm") or Input.is_action_just_pressed("cancel") ):
				await get_tree().create_timer(1.7).timeout
				sfx_player.stream = load("res://sfx ( tambien re ordenar)/Menu - Press Start 01.wav")
				sfx_player.play(0)
				game_manager.load_map()
				queue_free() 
