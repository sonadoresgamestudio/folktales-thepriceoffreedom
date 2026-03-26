class_name Knob extends InteractiveObject


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		if(map.door_is_open):
			await exploration_system.show_message(load("res://NoeliaDialogue.png"),"Noelia", "Huh? What's that?")
			await exploration_system.show_message(load("res://AshDialogue.png"),"Ash", "We've been discovered!")
			await exploration_system.add_message(load("res://AshDialogue.png"),"Ash", "Prepare yourself, Noelia!")
			if (exploration_system.gamestate != exploration_system.GameStates.BATTLE):
				exploration_system.game_manager.load_battle()
			exploration_system.gamestate = exploration_system.GameStates.BATTLE
		else:
			if(map.has_key):
				await exploration_system.show_message(load("res://NoeliaDialogue.png"),"Noelia", "Hey! We have the key already!")
				await exploration_system.show_message(load("res://AshDialogue.png"),"Ash", "Try the keyhole first...")
			else:
				map.box_has_key = true
				await exploration_system.show_message(load("res://NoeliaDialogue.png"),"Noelia", "Closed...")
				await exploration_system.show_message(load("res://AshDialogue.png"),"Ash", "There must be a key somewhere.")
				
