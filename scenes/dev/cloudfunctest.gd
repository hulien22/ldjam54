extends Node2D


func _ready():
	$Button.pressed.connect(self.submit);
	$HTTPRequest.request_completed.connect(_on_request_completed);


func submit():
	var json = JSON.stringify({
		"prompt": $LineEdit.text,
		"argument": $LineEdit2.text,
	});
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("https://us-central1-ldjam54.cloudfunctions.net/ldjam54", headers, HTTPClient.METHOD_POST, json);


func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	$Label.text = body.get_string_from_utf8()
