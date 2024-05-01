extends Node2D

# Import components
@onready var tile_map = $TileMap
@onready var player = $Player
@onready var camera = $Camera2D

# Camera system variables
var camera_target
var camera_zoom_speed = 0.1
var camera_min_zoom = Vector2(1, 1)
var camera_max_zomm = Vector2(4, 4)

func _ready():
	camera_target = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Camera workings
	_camera_update_zoom()
	_camera_update_position()

func _camera_update_position():
	if camera_target:
		camera.position = camera_target.position

func _camera_update_zoom():
	if Input.is_action_just_released("camera_zoom_in"):
		camera.zoom += Vector2(camera_zoom_speed, camera_zoom_speed)
	if Input.is_action_just_released("camera_zoom_out"):
		camera.zoom -= Vector2(camera_zoom_speed, camera_zoom_speed)
	camera.zoom = clamp(camera.zoom, camera_min_zoom, camera_max_zomm)