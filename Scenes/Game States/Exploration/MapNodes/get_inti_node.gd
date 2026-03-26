class_name GetIntiNode extends MapNode

var inti: Inti
@export var inti_name: String

func run_node_function():
	label.text = ("Conseguiste un Thunderball y ahora está en posesión de Noelia.")
	game_manager.noelia_data.inti_array.append(Thunderball.new())
	super()
