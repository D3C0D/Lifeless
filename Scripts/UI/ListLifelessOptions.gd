extends OptionButton

# Lifeless Locations
var default_path = "res://Lifeless Skins/"
var user_created_path = "user://Lifeless Skins/"

# Scan for Lifeless skins
@onready var default_folders : PackedStringArray
@onready var user_created_folders : PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the Folders
	default_folders = list_lifeless_Skins(default_path)
	user_created_folders = list_lifeless_Skins(user_created_path)

	# Add options to the list
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



func list_lifeless_Skins(dir_path): 
    # Open the directory and return all subfolders
	if DirAccess.dir_exists_absolute(dir_path):
		var dir = DirAccess.open(dir_path)
		var subdirectories = dir.get_directories()
        
		var results = []
		for skin in subdirectories:
			print(dir_path + skin + "/" + skin + ".json")
			var json_file = dir_path + skin + "/" + skin + ".json"
			var png_file = dir_path + skin + "/" + skin + ".png"

			if FileAccess.file_exists(json_file) and FileAccess.file_exists(png_file):
				results.append(skin)
        
		return results
	return []
