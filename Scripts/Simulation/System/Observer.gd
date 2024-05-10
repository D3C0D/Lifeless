extends Node2D

# Import components
@onready var camera = $Camera2D

# Camera system variables
var camera_zoom_speed = 0.1
var camera_is_dragging = false
var mouse_start_position : Vector2
var camera_min_zoom = Vector2(1, 1)
var camera_max_zomm = Vector2(4, 4)

# State Machine
enum observer_states{
	FREE_MOVE,
	FIXED
}
var current_observer_state = observer_states.FREE_MOVE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_camera_update_zoom()

func _camera_update_zoom():
	if not global.on_menu:
		if Input.is_action_just_released("camera_zoom_in"):
			camera.zoom += Vector2(camera_zoom_speed, camera_zoom_speed)
		if Input.is_action_just_released("camera_zoom_out"):
			camera.zoom -= Vector2(camera_zoom_speed, camera_zoom_speed)
		camera.zoom = clamp(camera.zoom, camera_min_zoom, camera_max_zomm)

# Camera movement
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton && event.is_action("camera_move"):
		get_viewport().set_input_as_handled();
		if event.is_pressed():
			mouse_start_position = event.position;
			camera_is_dragging = true;
			Herald.request_UI_hide_specific.emit("SpawnLifelessUI")
			global.on_menu = false
		else:
			camera_is_dragging = false;
	elif event is InputEventMouseMotion && camera_is_dragging:
		get_viewport().set_input_as_handled();
		position += (mouse_start_position - event.position);
		mouse_start_position = event.position;
