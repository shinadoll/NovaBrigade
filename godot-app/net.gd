extends HTTPRequest

var lastID
var lastAction
signal newAction

class Action:
	var userID: int
	var shortName: String
	var displayName: String

func _ready():
	# Create an HTTP request node and connect its completion signal.
	makeRequest()

	# Perform a POST request. The URL below returns JSON as of writing.
	# Note: Don't make simultaneous requests using a single HTTPRequest node.
	# The snippet below is provided for reference only.
	#var body = JSON.new().stringify({"name": "Godette"})
	#error = http_request.request("https://httpbin.org/post", [], HTTPClient.METHOD_POST, body)
	#if error != OK:
		#push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var action = json.get_data()
	
		# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	if (action):
		if (lastID != action.userID):
			lastID = action.userID
			lastAction = action
		
			newAction.emit(action)

func makeRequest():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	# Perform a GET request. The URL below returns JSON as of writing.
	var error = http_request.request("http://localhost:3000/values.json")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
	return 

func _process(delta):
	var recentRequest = makeRequest()
