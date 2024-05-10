extends Node

# <-----> ALL REQUEST SIGNALS <----->
# MUST FOLLOW PATTERN FOR READABILITY
#          verb_fromwho_what(whoami)
#          request_simulation_tilemap(emiter)

# Requests a new path for the player
signal request_navigation_path(emiter, current_point, target_point)

# Request to clear the path drawn ONLY FOR DEBUGGING
signal request_navigation_clear_path

# Request new generate complete
signal request_sentience_generative_completion(model: String, prompt: String, context: Array)

# Request new lifeless
signal request_lifeless_spawn_new(is_user_created: bool, fullname: String)

# Request change UI
signal request_UI_change(new_ui: String)

# Request hide all UI
signal request_UI_hide_specific(ui_to_hide: String)

# Request lifeless spawner UI move
signal request_lifelessui_change_position(new_position: Vector2)

# Request lifeless spawner UI move
signal request_lifelessui_change_spawn_position(new_spawn_position: Vector2)

# Request new chat
signal request_chatUI_new_chat(emiter, speaker_details: Dictionary, context)

# <-----> ALL RETURN SIGNALS <----->
# MUST FOLLOW PATTERN FOR READABILITY
#          verb_fromwho_what(towho, what)
#          return_simulation_tilemap(OriginalEmiter, Tilemap)

# Return a new path for the player
signal return_navigation_path(emiter, new_path)

# Return new generate complete
signal return_sentience_generative_completion(completion_request: Dictionary)

# Return new lifeless
signal return_lifeless_spawn_new(new_lifeless: Lifeless)

# Return end of chat
signal return_chatUI_end_chat(emiter, context: Array)