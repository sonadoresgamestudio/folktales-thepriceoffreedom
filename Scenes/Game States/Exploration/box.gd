class_name Box extends InteractiveObject


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		if (map.box_has_key):
			map.has_key = true
			await exploration_system.show_message(load("res://NoeliaDialogue.png"),"Noelia", "Hey, here it is!")
			await exploration_system.show_message(load("res://AshDialogue.png"),"Ash", " Good job, kiddo.")
			
		else:
			await exploration_system.show_message(load("res://AshDialogue.png"),"Ash","It's just a box.")
			await exploration_system.show_message(load("res://NoeliaDialogue.png"),"Noelia", "It seems a bit cleaner than the rest of the room \n for some reason.")
			
