extends Area2D

# Signals to comunicate with Simulation
signal player_requesting_new_path(current_point: Vector2i, target_point: Vector2i)

# Get a reference of the lifeless
@onready var player_lifeless = $Lifeless

# Click system timers and times
var blinking_timer = Timer.new()
var blinking_frequency = 0.3
var blinking_modulate = Color(1, 1, 1, .5)

# Movement system
var current_path
var movement_speed = 0.5
var currently_moving = false

# Payer animation system
var current_animation

# Player State Machine
enum player_states{
	IDLE,
	SELECTED,
	MOVING
}

var is_hovered = false

var current_player_state = player_states.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect return functions
	Herald.return_navigation_path.connect(_handle_return_navigation_path)

	# Connnect movment signals
	#move_tween.finished.connect(_handle_move_tween_finished)

	# Set timers
	blinking_timer.timeout.connect(_blinking_timer_timeout)
	add_child(blinking_timer)

	# <-----> DEBUG CODE ONLY <----->
	$Dummy.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Check if player is selected
	match current_player_state:
		player_states.IDLE:
			_handle_player_idle()
		player_states.SELECTED:
			_handle_player_selected()
		player_states.MOVING:
			_handle_player_moving()

# Mouse entered hover
func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	# Start hover
	is_hovered = true

# Mouse exited hover
func _on_mouse_exited():
	is_hovered = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

# <-----> FUNCTIONS TO HANLDE VISUAL EFFECTS <----->

# Blinking on selected
func _start_blinking(frequency):
	blinking_timer.wait_time = frequency
	modulate = blinking_modulate
	blinking_timer.start()

func _stop_blinking():
	blinking_timer.stop()
	modulate = Color(1, 1, 1, 1)
	visible = true

func _blinking_timer_timeout():
	if modulate == Color(1, 1, 1, 1):
		modulate = blinking_modulate
	else:
		modulate = Color(1, 1, 1, 1)


# <-----> FUNCTIONS TO HANLDE BEHAVIOR <----->
func  _handle_player_selected():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	if Input.is_action_just_pressed("select_point_map"):
		Herald.request_navigation_path.emit(self, floor(position / global.tile_size), floor(get_global_mouse_position() / global.tile_size))		
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		current_player_state = player_states.MOVING
		_stop_blinking()

func _handle_player_idle():
	if Input.is_action_just_pressed("select_lifeless") and is_hovered:
		current_player_state = player_states.SELECTED
		_start_blinking(blinking_frequency)

func _handle_player_moving():
	# Check if path is not empty and not currently moving
	if not current_path.is_empty() and not currently_moving:
		var move_tween = self.create_tween()
		move_tween.finished.connect(_handle_move_tween_finished)
		var temp_new_pos = Vector2(current_path.pop_back()) * global.tile_size + Vector2(global.tile_size / 2, global.tile_size / 2)
		_handle_player_moving_animation(true, (temp_new_pos - position).normalized())
		move_tween.tween_property(self, "position", temp_new_pos, movement_speed)
		move_tween.play()
		currently_moving = true
	elif current_path.is_empty() and not currently_moving: # If path is empty go back to idle
		current_player_state = player_states.IDLE
		Herald.request_navigation_clear_path.emit()
		_handle_player_moving_animation(false, Vector2.ZERO)
	
	# Cancel on click
	if Input.is_action_just_pressed("select_lifeless") and is_hovered:
		current_path = []
		current_player_state = player_states.IDLE
		Herald.request_navigation_clear_path.emit()
		_handle_player_moving_animation(false, Vector2.ZERO)

func _handle_player_moving_animation(_moving: bool, _direction: Vector2):
	if _moving:
		match _direction:
			Vector2.UP:
				var temp_animation_name = LPCAnimatedSprite2D.LPCAnimation.WALK_UP				
				current_animation = temp_animation_name
				player_lifeless.play(temp_animation_name)
			Vector2.DOWN:
				var temp_animation_name = LPCAnimatedSprite2D.LPCAnimation.WALK_DOWN
				current_animation = temp_animation_name
				player_lifeless.play(temp_animation_name)
			Vector2.LEFT:
				var temp_animation_name = LPCAnimatedSprite2D.LPCAnimation.WALK_LEFT
				current_animation = temp_animation_name
				player_lifeless.play(temp_animation_name)
			Vector2.RIGHT:
				var temp_animation_name = LPCAnimatedSprite2D.LPCAnimation.WALK_RIGHT
				current_animation = temp_animation_name
				player_lifeless.play(temp_animation_name)
	else:
		match current_animation:
			LPCAnimatedSprite2D.LPCAnimation.WALK_UP:
				var temp_animation_name = LPCAnimatedSprite2D.LPCAnimation.IDLE_UP
				current_animation = temp_animation_name
				player_lifeless.play(temp_animation_name)
			LPCAnimatedSprite2D.LPCAnimation.WALK_DOWN:
				var temp_animation_name = LPCAnimatedSprite2D.LPCAnimation.IDLE_DOWN
				current_animation = temp_animation_name
				player_lifeless.play(temp_animation_name)
			LPCAnimatedSprite2D.LPCAnimation.WALK_LEFT:
				var temp_animation_name = LPCAnimatedSprite2D.LPCAnimation.IDLE_LEFT
				current_animation = temp_animation_name
				player_lifeless.play(temp_animation_name)
			LPCAnimatedSprite2D.LPCAnimation.WALK_RIGHT:
				var temp_animation_name = LPCAnimatedSprite2D.LPCAnimation.IDLE_RIGHT
				current_animation = temp_animation_name
				player_lifeless.play(temp_animation_name)



# <-----> FUNCTIONS TO HANLDE SINGNALS <----->
func _handle_return_navigation_path(emiter, new_path: Array):
	if emiter == self:
		current_path = new_path
		current_path.reverse()

# Move tween finish
func _handle_move_tween_finished():
	currently_moving = false

func _handle_request_player_new_character(is_user_created: bool, full_name: String):
	pass