extends Node

# HTTP Request
var http_request_generate_completion = HTTPRequest.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add HTTP Request as child and connect signals
	add_child(http_request_generate_completion)
	http_request_generate_completion.request_completed.connect(_handle_generate_completion)

	# Connect to Herald for communication across nodes using the bus
	Herald.request_sentience_generative_completion.connect(_generate_completion)

# Connected to the signal "http_request_generate_completion" so it can be called from the UI
func _generate_completion(model: String, prompt: String, context: Array):
	# Prepare the endpoint and make the reques
	var endpoint = global.address + ":" + global.port + global.path_generate
	# Prepare parameters to send
	var parameters = {
			"model": model,
			"prompt": prompt,
			"context": context,
			"stream": false
		}
	
	# Prepare headers as a PackedArray
	var headers = [
		"Content-Type: application/json"
	]
	
	# Make the request
	http_request_generate_completion.request(endpoint, headers, HTTPClient.METHOD_POST, JSON.stringify(parameters))

# Handles the Generated response and returns it down the pipeline to be displayed
func _handle_generate_completion(_result, response_code, _headers, body):
	if response_code == 200:
		var body_dictionary = JSON.parse_string(body.get_string_from_utf8())
		Herald.return_sentience_generative_completion.emit(body_dictionary)
	else:
		Herald.return_sentience_generative_completion.emit({})

