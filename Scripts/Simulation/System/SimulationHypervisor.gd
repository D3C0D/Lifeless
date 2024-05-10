extends Node2D

# Import components
@onready var tile_map = $TileMap
@onready var player = $Player
@onready var observer = $Observer
@onready var lifeless_spawner = $Services/LifelessSpawnSystem

# Tilemap var
var collisions_layer = 0
var is_solid = "is_solid"

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("create_new_sentient") and not global.on_menu:
		global.on_menu = true
		open_create_lifeless_ui()	
	if Input.is_action_just_pressed("ui_cancel") and not global.on_menu:
		global.on_menu = true
		Herald.request_UI_change.emit("Configurations")


func open_create_lifeless_ui():
	if not _check_cell_is_solid(get_global_mouse_position()):
		Herald.request_UI_change.emit("SpawnLifelessUI")
		Herald.request_lifelessui_change_position.emit(get_viewport().get_mouse_position())
		Herald.request_lifelessui_change_spawn_position.emit(get_global_mouse_position())

func _check_cell_is_solid(mouse_location:Vector2) -> bool:
	var cell_to_check_position = floor(mouse_location / global.tile_size)
	var cell_on_tilemap = tile_map.get_cell_atlas_coords(collisions_layer, cell_to_check_position)
	if not cell_on_tilemap == Vector2i(-1,-1):
		return tile_map.get_cell_tile_data(collisions_layer, cell_to_check_position).get_custom_data(is_solid)
	return false
