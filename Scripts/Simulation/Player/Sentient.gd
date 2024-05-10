extends Area2D

# Get Lifeless Reference
@onready var my_lifeless = $Lifeless

# Sentient State Machine
enum player_states{
	IDLE,
	MOVING
}

var is_hovered = false
var current_player_state = player_states.IDLE

# Keep Context of conversation
var my_context = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Herald System
	Herald.return_chatUI_end_chat.connect(_handle_return_chatUI_end_chat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Sentient State Machine
	match current_player_state:
		player_states.IDLE:
			_handle_sentient_idle()
		player_states.MOVING:
			_handle_sentient_moving()

# Mouse entered hover
func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	# Start hover
	is_hovered = true

# Mouse exited hover
func _on_mouse_exited():
	is_hovered = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

# Handle Herald Returns
func _handle_return_chatUI_end_chat(emiter, context: Array):
	if emiter == self:
		my_context = context

# <-----> FUNCTIONS TO HANLDE BEHAVIOR <----->
func _handle_sentient_idle():
	if Input.is_action_just_pressed("select_lifeless") and is_hovered:
		var distance_to_player = abs(position - get_tree().root.get_node("Simulation/Player").position)
		if distance_to_player <= Vector2(global.tile_size, global.tile_size):
			Herald.request_UI_change.emit("ChatUI")
			Herald.request_chatUI_new_chat.emit(self, my_lifeless.LifelessData, my_context)
			global.on_menu = true

func _handle_sentient_moving():
	pass