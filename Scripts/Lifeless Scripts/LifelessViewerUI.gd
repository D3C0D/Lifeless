extends Control

# References to UI and Spawner
@onready var selected_lifeless = $LifelessSelect
@onready var selected_animation = $AnimationSelect
@onready var spawn_lifeless = $SpawnLifeless
@onready var lifeless_spawner = $LifelessSpawner

# Current Lifeless
var current_lifeless : Lifeless

# Scale value
var scale_factor = Vector2(2, 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	var id_count = 1

	# push default lifeless list
	selected_lifeless.add_separator("Default")
	for option in (lifeless_spawner as LifelessSpawner).default_folders:
		selected_lifeless.add_item(option.replace("_", " "), id_count)
		selected_lifeless.set_item_metadata(selected_lifeless.get_item_index(id_count), false)
		id_count += 1

	# push user created lifeless list
	selected_lifeless.add_separator("User Created")
	for option in (lifeless_spawner as LifelessSpawner).user_created_folders:
		selected_lifeless.add_item(option.replace("_", " "), id_count)
		selected_lifeless.set_item_metadata(selected_lifeless.get_item_index(id_count), true)
		id_count += 1

	# Load the animations name
	for animation in LPCAnimatedSprite2D.LPCAnimation:
		selected_animation.add_item(animation)

func _on_spawn_lifeless_pressed():
	if current_lifeless:
		current_lifeless.queue_free()
	var selected_index = selected_lifeless.get_item_index(selected_lifeless.get_selected_id())
	current_lifeless = (lifeless_spawner as LifelessSpawner).create_lifeless(selected_lifeless.get_selected_metadata(), selected_lifeless.get_item_text(selected_index).replace(" ", "_"))
	current_lifeless.scale = scale_factor

func _on_animation_select_item_selected(index:int):
	if current_lifeless:
		(current_lifeless as Lifeless).lifeless_skin.play(index)
