extends Node

# Lifeless Locations
var default_path = "res://Lifeless Skins/"
var user_created_path = "user://Lifeless Skins/"

# References
var lifeless = preload("res://Objects/Lifeless.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Herald.request_lifeless_spawn_new.connect(_handle_request_lifeless_spawn_new)

func _handle_request_lifeless_spawn_new(is_user_created, full_name):
	# Instanciate the new lifeless
	var temp_lifeless = lifeless.instantiate()
	
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
	
	# Return lifeless
	Herald.return_lifeless_spawn_new.emit(temp_lifeless)

func get_lifeless_data(directory, file_name):
	var file = directory + file_name + "/" + file_name + ".json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict