extends Control

# Current Lifeless
var current_lifeless : Lifeless
# UI references
@onready var name_edit = $NameEdit
@onready var surname_edit = $SurnameEdit
@onready var description_edit = $DescriptionEditScroll/DescriptionEdit
@onready var error_notif = $ErrorNotification
@onready var error_notif_timer = $ErrorNotification/Timer
@onready var how_to_label = $BackgroundColor/CenterContainer/LifelessView/Howtolable
@onready var selected_animation = $SelectAnimation
var spritesheet : String

# Lifeless reference
var lifeless = preload("res://Objects/Lifeless.tscn")

# Directory locations
var user_created_path = "user://Lifeless Skins/"

# Center of Screen
var center_of_screen = Vector2(640, 360)
var scale_factor = Vector2(4, 4)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the animations name
	for animation in LPCAnimatedSprite2D.LPCAnimation:
		selected_animation.add_item(animation)

func create_lifeless(temp_texture):
	if current_lifeless:
		current_lifeless.queue_free()
	# Instanciate the new lifeless
	current_lifeless = lifeless.instantiate()
	get_tree().root.get_node("/root/LifelessCreator").add_child(current_lifeless)
	
	# Prompt to create the skin
	(current_lifeless as Lifeless)._set_lifeless_skin(temp_texture)
	(current_lifeless as Lifeless).position = center_of_screen
	(current_lifeless as Lifeless).scale = scale_factor
	how_to_label.visible = false

func _send_notification(error_text):
	error_notif.text = error_text
	error_notif_timer.start(5)

func _on_notif_timer_timeout():
	error_notif.text = ""

func _on_open_sprite_sheet_folder_pressed():
	if name_edit.text == "" or surname_edit.text == "":
		_send_notification("You must add a name and Surname first")
		return
	var temp_dir = user_created_path + name_edit.text + "_" + surname_edit.text
	print(OS.get_user_data_dir(), "    ", temp_dir)
	if not DirAccess.dir_exists_absolute(temp_dir):
		DirAccess.make_dir_recursive_absolute(temp_dir)
	OS.shell_open(ProjectSettings.globalize_path(temp_dir))


func _on_reload_skin_pressed():
	# Check there is a name and surname, otherwise error out
	if name_edit.text == "" or surname_edit.text == "":
		_send_notification("You must add a name and Surname first")
		return
	#Create directory and file names
	var temp_dir = user_created_path + name_edit.text + "_" + surname_edit.text + "/"
	var file_name = name_edit.text + "_" + surname_edit.text + ".png"
	# Check directory exist, if not, create
	if not DirAccess.dir_exists_absolute(temp_dir):
		DirAccess.make_dir_absolute(temp_dir)
	# Load image file
	var temp_image = Image.load_from_file(temp_dir + file_name)
	# Check of image was able to load
	if not temp_image:
		_send_notification("Image not found or can't be loaded")
		return
	# Make a texture for the lifeless and create it
	var temp_texture = ImageTexture.create_from_image(temp_image)
	create_lifeless(temp_texture)


func _on_save_lifeless_pressed():
	# Check there is a name and surname, otherwise error out
	if name_edit.text == "" or surname_edit.text == "":
		_send_notification("You must add a name and Surname first")
		return
	#Create directory and file names
	var temp_dir = user_created_path + name_edit.text + "_" + surname_edit.text + "/"
	var file_name = name_edit.text + "_" + surname_edit.text + ".json"
	# Check directory exist, if not, create
	if not DirAccess.dir_exists_absolute(temp_dir):
		DirAccess.make_dir_recursive_absolute(temp_dir)
	
	# Create a temporary Dictionary to parse the Json file
	var temp_dictionary = {
		"Name": name_edit.text,
		"Surname": surname_edit.text,
		"Description": description_edit.text
	}

	# Open file json to write the data
	var temp_json = FileAccess.open(temp_dir + file_name, FileAccess.WRITE_READ)
	temp_json.store_string(JSON.stringify(temp_dictionary))
	_send_notification("Done and Saved!")
		


func _on_select_animation_item_selected(index):
	if current_lifeless:
		(current_lifeless as Lifeless).lifeless_skin.play(index)


func _on_open_lpc_creator_pressed():
	OS.shell_open("https://sanderfrenken.github.io/Universal-LPC-Spritesheet-Character-Generator/")
