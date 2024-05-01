extends Node

# <-----> ALL REQUEST SIGNALS <----->
# MUST FOLLOW PATTERN FOR READABILITY
#          verb_fromwho_what(whoami)
#          request_simulation_tilemap(emiter)

# Requests a new path for the player
signal request_navigation_path(emiter, current_point, target_point)

# Request to clear the path drawn ONLY FOR DEBUGGING
signal request_navigation_clear_path



# <-----> ALL RETURN SIGNALS <----->
# MUST FOLLOW PATTERN FOR READABILITY
#          verb_fromwho_what(towho, what)
#          return_simulation_tilemap(OriginalEmiter, Tilemap)

# Returns a new path for the player
signal return_navigation_path(emiter, new_path)