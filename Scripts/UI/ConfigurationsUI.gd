extends Control

# Imports for UI
@onready var model_select = $AvaiblableModels
@onready var world_description = $WorldDescription
@onready var address_text = $Address
@onready var port_text = $Port

func _ready():
	address_text.text = global.address
	port_text.text = global.port

func _on_avaiblable_models_item_selected(index:int):
	global.sentience_model = model_select.get_item_text(index)


func _on_world_description_text_changed():
	global.world_setting = world_description.text


func _on_button_button_down():
	global.on_menu = false
	Herald.request_UI_hide_specific.emit("Configurations")

func _on_address_text_changed():
	global.address = address_text.text

func _on_port_text_changed():
	global.port = port_text.text
