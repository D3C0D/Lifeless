extends Node2D

class_name Lifeless

# Personality Variables
var LifelessData = {
	"Name": "Shallan",
	"Surname": "Davar",
	"Description": "I am Shallan, a knight radiant and a scholar"
}

# Check to Know where to find the files
var is_user_created = false

# Create LPC Animation object
var lifeless_skin = LPCAnimatedSprite2D.new()

func _ready():
	add_child(lifeless_skin)
	_set_lifeless_skin()

# Called when you want to set the skin
func _set_lifeless_skin():
	var skin_spritesheet = LPCSpriteSheet.new()
	(skin_spritesheet as LPCSpriteSheet).SpriteSheet = _load_lifeless_skin()
	(skin_spritesheet as LPCSpriteSheet).Name = LifelessData.get("Name") + "_" + LifelessData.get("Surname")
	(lifeless_skin as LPCAnimatedSprite2D).SpriteSheets = [skin_spritesheet]
	(lifeless_skin as LPCAnimatedSprite2D).LoadAnimations()

func _load_lifeless_skin():
	# select directory depending on user created
	var directory : String
	# Generate Folder Name
	var folder = LifelessData.get("Name") + "_" + LifelessData.get("Surname") + "/"	
	# Create file Name
	var file = LifelessData.get("Name") + "_" + LifelessData.get("Surname") + ".png"
	
	if is_user_created:
		directory = "user://Lifeless Skins/"
		var temp_image = Image.load_from_file(directory + folder + file)
		var temp_texture = ImageTexture.create_from_image(temp_image)
		return temp_texture
	else:
		directory = "res://Lifeless Skins/"
		# Load skin from disk
		return load(directory + folder + file)
	
# Called to pass the animation down the line
func play(animation: LPCAnimatedSprite2D.LPCAnimation):
	lifeless_skin.play(animation)