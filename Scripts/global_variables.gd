extends Node

# Declaring endpoint settings
var address = "http://127.0.0.1"
var port = "11434"

# Declaring API Paths
var path_list = "/api/tags"
var path_generate = "/api/generate"

# Declaring selected global model
var sentience_model = "llama3:latest"
var world_setting = ""

# Controll if player is on a menu
var on_menu = false

# Navigation and Tiles
var tile_size = 32

# Default Lifeless list
var default_lifeless = [
	"Shallan_Davar",
	"Headless_Horseman"
]

# Debug tools
func _process(_delta):
	# Close Game if in debug
	if Input.is_action_just_pressed("debug_back_debug_menu"):
		if get_tree().current_scene.name == "TestingHub":
			get_tree().quit()
		else:
			get_tree().change_scene_to_file("res://Scenes/TestingHub.tscn")
	
	# Open Debug Menu
