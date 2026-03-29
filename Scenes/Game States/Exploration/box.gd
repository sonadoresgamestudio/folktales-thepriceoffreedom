class_name Box extends InteractiveObject


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (Input.is_action_just_pressed("left_click")):
		if(!exploration_system.is_there_text):
			exploration_system.is_there_text = true
			if (map.box_has_key):
				map.has_key = true
				await exploration_system.show_message(load(game_manager.load_file("noelia_dialogue_idle")),"Noelia", "Hey, here it is!")
				exploration_system.sfx_player.set_stream(exploration_system.sfx2)
				exploration_system.sfx_player.play()
				await exploration_system.show_message(load(game_manager.load_file("noelia_dialogue_idle")),"SYSTEM", "Picked up key.")
				await exploration_system.show_message(load(game_manager.load_file("ash_dialogue_idle")),"Ash", " Good job, kiddo.")
			else:
				await exploration_system.show_message(load(game_manager.load_file("ash_dialogue_idle")),"Ash","It's just a box.")
				await exploration_system.show_message(load(game_manager.load_file("noelia_dialogue_idle")),"Noelia", "It seems a bit cleaner than the rest of the room \n for some reason.")
			await get_tree().create_timer(0.1).timeout
			exploration_system.is_there_text = false
