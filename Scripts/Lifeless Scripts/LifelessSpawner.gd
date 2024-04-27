extends Node

class_name LifelessSpawner

# Lifeless Locations
var default_path = "res://Lifeless Skins/"
var user_created_path = "user://Lifeless Skins/"

# Scan for Lifeless skins
@onready var default_folders : PackedStringArray
@onready var user_created_folders : PackedStringArray

# References
var lifeless = preload("res://Objects/Lifeless.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	default_folders = list_lifeless_Skins(default_path)
	user_created_folders = list_lifeless_Skins(user_created_path)

func list_lifeless_Skins(dir_path):
	# Open the directory and return all subfolders
	if DirAccess.dir_exists_absolute(dir_path):
		var dir = DirAccess.open(dir_path)
		var subdirectories = dir.get_directories()
		return subdirectories
	return []

func create_lifeless(is_user_created, full_name):
	# Instanciate the new lifeless
	var temp_lifeless = lifeless.instantiate()
	get_tree().root.get_child(0).add_child(temp_lifeless)
	
	# set the directory depending on user create
	var directory : String
	if is_user_created:
		directory = user_created_path
	else:
		directory = default_path
	
	# Set the data on the lifeless memory
	(temp_lifeless as Lifeless).LifelessData = get_lifeless_data(directory, full_name)
	(temp_lifeless as Lifeless).is_user_created = is_user_created
	
	# Prompt to create the skin
	(temp_lifeless as Lifeless)._set_lifeless_skin()
	
	# Return lifeless incase it is needed
	return temp_lifeless

func get_lifeless_data(directory, file_name):
	var file = directory + file_name + "/" + file_name + ".json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict
