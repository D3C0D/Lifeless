extends Node

# Declaring endpoint settings
var address = "http://127.0.0.1"
var port = "11434"

# Declaring API Paths
var path_list = "/api/tags"
var path_generate = "/api/generate"

# Navigation and Tiles
var tile_size = 32

# Debug tools
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().current_scene.name == "TestingHub":
			get_tree().quit()
		else:
			get_tree().change_scene_to_file("res://Scenes/TestingHub.tscn")
