extends CanvasLayer

# Import UI Modules
@onready var chat_ui = $ChatUI


# Called when the node enters the scene tree for the first time.
func _ready():
	Herald.request_UI_change.connect(_handle_request_UI_change)
	Herald.request_UI_hide_specific.connect(_handle_request_UI_hide_specific)

func _handle_request_UI_change(new_ui):
	# Set all UI as not visible
	var temp_ui_nodes = get_children()
	for child in temp_ui_nodes:
		child.visible = false
	# Make the new UI visible
	get_node(new_ui).visible = true

func _handle_request_UI_hide_specific(ui_to_hide: String):
	# Make the UI invisible
	get_node(ui_to_hide).visible = false