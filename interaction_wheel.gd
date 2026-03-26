class_name InteractionWheel extends Control

var options: Array[Button] = []
var needed: int #la cantidad de opciones que deben aparecer cuando spawneé la wheel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in needed:
		options.append(Button.new())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
