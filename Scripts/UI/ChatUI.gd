extends Control

# Imports For UI
@onready var user_prompt = $PromptContainer/UserPrompt
@onready var chat_box_container = $ChatMessagesScroll/ChatMessages
@onready var chat_speaker_name_label = $LifelessNameContainer/LifelessNameLabel
@onready var chat_message_template = preload("res://Scenes/ChatUI/ChatMessage.tscn")
@onready var loading_animation = $LoadingAnimation

# Speaker Details
var speaker_details = {
	"Name":"Shallan",
	"Surname":"Davar",
	"Description":"Hello"
}

# Keep context of the conversation
var chat_context = []
var current_emiter

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect with Herald
	Herald.return_sentience_generative_completion.connect(_handle_return_sentience_generative_completion)
	Herald.request_chatUI_new_chat.connect(_handle_request_chatUI_new_chat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not visible:
		return
	# Handle send input
	if Input.is_action_just_pressed("chat_ui_send_message"):
		_handle_send_message()
	
	# Hndle hide UI
	if Input.is_action_just_pressed("ui_cancel"):
		_end_chat_now()

func _end_chat_now():
	Herald.return_chatUI_end_chat.emit(current_emiter, chat_context)
	Herald.request_UI_hide_specific.emit("ChatUI")
	user_prompt.text = ""
	chat_context = []
	current_emiter = null
	_clear_chat_history()

func _clear_chat_history():
	for message in chat_box_container.get_children():
		message.queue_free()

func _handle_send_message():
	var temp_user_prompt
	# If this is the first message add the personality to the sentient memory
	if chat_context.is_empty():
		temp_user_prompt = "You are " + speaker_details.get("Name") + " " + speaker_details.get("Surname") + ", a brief description of you can be: " + speaker_details.get("Description") + ". Answer as such and dont break character. Here is the context of the world we are in: " + global.world_setting + "Here is the first message from the user, respond to this only:" + user_prompt.text 
	else:
		temp_user_prompt = user_prompt.text
	# Make Request to Sentience System for a generation
	Herald.request_sentience_generative_completion.emit(global.sentience_model, temp_user_prompt, chat_context)

	# Make loading visible animation
	loading_animation.visible = true

	# Add user message to the chat
	var temp_chat_message = chat_message_template.instantiate()
	temp_chat_message.get_node("Role").text = "You"
	temp_chat_message.get_node("Message").text = user_prompt.text	
	chat_box_container.add_child(temp_chat_message)

	# Clear user prompt
	user_prompt.text = ""

func _handle_return_sentience_generative_completion(request_data):
	loading_animation.visible = false
	var temp_chat_message
	if request_data == {}: # If request failed, notify user
		temp_chat_message = chat_message_template.instantiate()
		temp_chat_message.get_node("Role").text = "System"
		temp_chat_message.get_node("Message").text = "Request Failed"
		chat_box_container.add_child(temp_chat_message)
		return
	# If OK, process as normal
	temp_chat_message = chat_message_template.instantiate()
	temp_chat_message.get_node("Role").text = speaker_details.get("Name")
	temp_chat_message.get_node("Message").text = str(request_data.get("response"))
	chat_context = request_data.get("context")
	chat_box_container.add_child(temp_chat_message)

func _handle_request_chatUI_new_chat(emiter, _speaker_details: Dictionary, context):
	speaker_details = _speaker_details
	current_emiter = emiter
	chat_context = context
	chat_speaker_name_label.text = speaker_details.get("Name") + " " + speaker_details.get("Surname")
