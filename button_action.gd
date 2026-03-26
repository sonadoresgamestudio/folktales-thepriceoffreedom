class_name ButtonAction extends Label

var action: Callable
@onready var cursor_spawn: Node2D = get_node("Cursor Spawn")

func _ready() -> void:
	cursor_spawn.position = self.position - Vector2(25, -9) #modificar cuando se haga responsive la mierda esta AAAAAAAAAAAAAAAAAAAAAAAAAAAA
