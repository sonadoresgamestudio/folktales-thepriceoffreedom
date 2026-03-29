class_name Keyhole extends InteractiveObject


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		if(!exploration_system.is_there_text):
			exploration_system.is_there_text = true
			if(map.has_key):
				map.door_is_open = true
				await exploration_system.show_message(load(game_manager.load_file("noelia_dialogue_idle")),"Noelia", "Can't wait to get out of here!")
				await exploration_system.show_message(load(game_manager.load_file("ash_dialogue_idle")),"Ash", "Just unlock it already...")
				exploration_system.sfx_player.set_stream(exploration_system.sfx1)
				exploration_system.sfx_player.play()
				await exploration_system.show_message(load(game_manager.load_file("noelia_dialogue_idle")), "SYSTEM", "*clank*")
				exploration_system.sfx_player.stop()
				await exploration_system.show_message(load(game_manager.load_file("noelia_dialogue_idle")), "Noelia", "Great! Now, yes...")
				await exploration_system.add_message(load(game_manager.load_file("noelia_dialogue_idle")), "Noelia", "Let's open it!")
				
			else:
				map.box_has_key = true
				await exploration_system.show_message(load(game_manager.load_file("noelia_dialogue_idle")),"Noelia", "We definitely need a key.")
				await exploration_system.show_message(load(game_manager.load_file("ash_dialogue_idle")),"Ash", "I agree. Let's search thoroughly.")
			await get_tree().create_timer(0.1).timeout
			exploration_system.is_there_text = false
