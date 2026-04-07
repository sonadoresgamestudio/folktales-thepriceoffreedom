class_name GameManager extends Node

enum GameStates {MAINMENU, CUTSCENE, EXPLORATION, BATTLE, PARTYMENU} #main menu donde empezás el juego, party menu donde curás a tus personajes y les equipás giladas

@onready var gamestate: GameStates = GameStates.MAINMENU

const file_directory_path: String = "res://A JSON folder/file_directory.json" # REVISAR ESTA LÍNEA si hay problemas en encontrar el directorio

#var main_menu: MainMenu
#var cutscene_scene: PackedScene
#var exploration_system: ExplorationSystem
#var battle_system: BattleSystem
#var party_menu_scene: PackedScene

var do_not_delete: PackedScene

var noelia_data: NoeliaData
var ash_data: AshData
var omar_data: OmarData

func _ready():
	noelia_data = NoeliaData.new() #estos dos se modifican cuando exista el concepto de "new game"
	ash_data = AshData.new()
	load_main_menu()

#region CargarEscenas 
#revisar si quiero esto acá
func load_main_menu():
	gamestate = GameStates.MAINMENU
	var scene_string: String = load_file("main_menu_scene")
	var main_menu = load(scene_string).instantiate()
	add_child(main_menu)

func load_battle():
	if(gamestate != GameStates.BATTLE):
		gamestate = GameStates.BATTLE
		var scene_string: String = load_file("battle_system_scene")
		var battle_system = load(scene_string).instantiate()
		add_child(battle_system)

func load_map():
	if(gamestate != GameStates.EXPLORATION):
		gamestate = GameStates.EXPLORATION
		var scene_string: String = load_file("exploration_system_scene") #meterle polish
		var exploration_system = load(scene_string).instantiate()
		add_child(exploration_system)
#endregion

func delete_scenes(do_not: PackedScene):
	pass
	

static func load_file_directory():
	var file_string = FileAccess.get_file_as_string(file_directory_path)
	var file_directory
	if file_string != null:
		file_directory = JSON.parse_string(file_string)
	else:
		push_warning("load_file_directory failed get_file_as_string for path: ", file_directory_path)
	
	if file_directory == null:
		push_error("load_file_directory failed to parse file data to JSON for ", file_directory_path)
	
	return file_directory

static func load_file(keyword: String):
	var file_directory = load_file_directory()
	var path: String = file_directory[keyword] #revisar posible error
	
	return path

static func load_json_data(keyword: String):
	var file_directory = load_file_directory()
	var path: String = file_directory[keyword]
	
	var file_string = FileAccess.get_file_as_string(path)
	var json_data
	if file_string != null:
		json_data = JSON.parse_string(file_string)
	else:
		push_warning("load_json_data_from_path failed get_file_as_string for path: ", path)
	
	if json_data == null:
		push_error("load_json_data_from_path failed to parse file data to JSON for ", path)
	
	return json_data
