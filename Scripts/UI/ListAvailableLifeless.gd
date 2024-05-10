extends OptionButton

# Lifeless Locations
var default_path = "res://Lifeless Skins/"
var user_created_path = "user://Lifeless Skins/"

# Scan for Lifeless skins
var default_folders = global.default_lifeless
var user_created_folders : PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready():
	user_created_folders = list_lifeless_Skins(user_created_path)
	add_options_to_button()

func list_lifeless_Skins(dir_path):
	# Open the directory and return all subfolders that have both a PNG and JSON file
	if DirAccess.dir_exists_absolute(dir_path):
		var temp_list = []
		var subdirectories = DirAccess.get_directories_at(dir_path)
		for subdirectory in subdirectories:
			var temp_json_file = dir_path + subdirectory + "/" + subdirectory + ".json"
			var temp_png_file = dir_path + subdirectory + "/" + subdirectory + ".png"
			if FileAccess.file_exists(temp_json_file) and FileAccess.file_exists(temp_png_file):
				temp_list.append(subdirectory.replace("_"," "))
		return temp_list
	return []

func add_options_to_button():
	var id_count = 1

	# push default lifeless list
	add_separator("Default")
	for option in default_folders:
		add_item(option.replace("_", " "), id_count)
		set_item_metadata(get_item_index(id_count), false)
		id_count += 1

	# push user created lifeless list
	add_separator("User Created")
	for option in user_created_folders:
		add_item(option.replace("_", " "), id_count)
		set_item_metadata(get_item_index(id_count), true)
		id_count += 1