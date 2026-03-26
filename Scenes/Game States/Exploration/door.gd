class_name Door extends InteractiveObject


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		if(map.has_key):
			await exploration_system.show_message(load("res://NoeliaDialogue.png"),"Noelia", "Can't wait to get out of here! :D")
			await exploration_system.show_message(load("res://AshDialogue.png"),"Ash", "Just unlock it already...")
		else:
			await exploration_system.show_message(load("res://NoeliaDialogue.png"),"Noelia", "Hey, a door!")
			await exploration_system.show_message(load("res://AshDialogue.png"),"Ash", "Try the knob.")
