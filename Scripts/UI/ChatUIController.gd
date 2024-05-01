extends Node

# Setting up variables to send the requests
@onready var user_prompt = $UserPrompt
@onready var chat_box = $ChatBox/RichTextLabel
@onready var model_select = $SelectModel
@onready var context = []
@onready var system_description = []

# Loading Animation
@onready var loading_animation = $LoadingAnimation


func _on_send_button_pressed():
	# Create the HTTPRequest and add it as a child
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	# Prepare the endpoint and make the reques
	var endpoint = global.address + ":" + global.port + global.path_generate
	# Prepare parameters to send
	var parameters = {
			"model": model_select.get_item_text(model_select.get_selected_id()),
			"prompt": user_prompt.text,
			"context": context,
			"stream": false
		}
	
	# Prepare headers as a PackedArray
	var headers = [
		"Content-Type: application/json"
	]
	
	# Make the request
	http_request.request(endpoint, headers, HTTPClient.METHOD_POST, JSON.stringify(parameters))
	
	# Clear user input and enable loading animation
	chat_box.clear()
	user_prompt.clear()
	loading_animation.visible = true

func _http_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		loading_animation.visible = false
		var body_dictionary = JSON.parse_string(body.get_string_from_utf8())
		chat_box.append_text(str(body_dictionary.get("response")))
		context = body_dictionary.get("context")
	else:
		# Request failed, handle the error
		print("Request failed. Response code:", response_code)
