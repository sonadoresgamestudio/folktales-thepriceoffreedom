class_name Keyhole extends InteractiveObject


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		if(map.has_key):
			map.door_is_open = true
			await exploration_system.show_message(load("res://NoeliaDialogue.png"),"Noelia", "Can't wait to get out of here!")
			await exploration_system.show_message(load("res://AshDialogue.png"),"Ash", "Just unlock it already...")
			await exploration_system.show_message(load("res://NoeliaDialogue.png"), "", "*clank*")
			await exploration_system.show_message(load("res://NoeliaDialogue.png"), "Noelia", "Great! Now, yes...")
			await exploration_system.add_message(load("res://NoeliaDialogue.png"), "Noelia", "Let's open it!")
			
		else:
			map.box_has_key = true
			await exploration_system.show_message(load("res://NoeliaDialogue.png"),"Noelia", "We definitely need a key.")
			await exploration_system.show_message(load("res://AshDialogue.png"),"Ash", "I agree. Let's search thoroughly.")
