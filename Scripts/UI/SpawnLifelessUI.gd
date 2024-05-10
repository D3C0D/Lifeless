extends Control

# Spawn variables
var spawn_position

# Imports of lifeless select
@onready var lifeless_options = $LifelessSelect

# References
var sentient = preload("res://Objects/Sentient.tscn")

# Lifeless Locations
var default_path = "res://Lifeless Skins/"
var user_created_path = "user://Lifeless Skins/"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Herald system
	Herald.request_lifelessui_change_position.connect(_handle_request_lifelessui_change_position)
	Herald.request_lifelessui_change_spawn_position.connect(_handle_request_lifelessui_change_spawn_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _handle_request_lifelessui_change_position(new_position: Vector2):
	position = new_position

func _handle_request_lifelessui_change_spawn_position(new_spawn_position: Vector2):
	var convert_to_cell_position = floor(new_spawn_position / global.tile_size)
	var cell_to_coordinates = floor(convert_to_cell_position * global.tile_size + Vector2(floor(global.tile_size / 2), floor(global.tile_size / 2)))
	spawn_position = cell_to_coordinates

func _on_lifeless_select_item_selected(index:int):
	Herald.request_UI_hide_specific.emit("SpawnLifelessUI")
	global.on_menu = false
	var new_lifeless = create_sentient(lifeless_options.get_selected_metadata(), lifeless_options.get_item_text(index).replace(" ", "_"))
	new_lifeless.position = spawn_position
	get_tree().root.get_node("Simulation").add_child(new_lifeless)

func create_sentient(is_user_created, full_name):
	# Instanciate the new lifeless
	var temp_sentient = sentient.instantiate()
	var temp_lifeless = temp_sentient.get_node("Lifeless")
	
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
	
	# Return sentient incase it is needed
	return temp_sentient

func get_lifeless_data(directory, file_name):
	var file = directory + file_name + "/" + file_name + ".json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	return json_as_dict