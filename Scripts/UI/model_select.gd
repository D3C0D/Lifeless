extends OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create the HTTPRequest and add it as a child
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	# Prepare the endpoint and make the reques
	var endpoint = global.address + ":" + global.port + global.path_list
	http_request.request(endpoint)

func _http_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		# Request successful, handle the response body
		var body_data = body.get_string_from_utf8()
		var models_list = get_model_names(JSON.parse_string(body_data))
		for model_name in models_list:
			self.add_item(model_name)
	else:
		# Request failed, handle the error
		print("Request failed. Response code:", response_code)

func get_model_names(json_data):
	var names := []
	if json_data.has("models"):
		for model in json_data["models"]:
			if model.has("name"):
				names.append(model["name"])
	return names
