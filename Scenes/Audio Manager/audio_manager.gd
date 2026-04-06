class_name AudioManager extends Node

@export var music_player: AudioStreamPlayer
@export var sfx_player: AudioStreamPlayer

@export var music_playlist: Array[AudioStream]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_sfx(keyword: String):
	var sfx_directory = GameManager.load_json_data("sfx_directory")
	sfx_player.set_stream(load(sfx_directory[keyword]))
	sfx_player.play()
