extends CanvasLayer

var chatTextEdit
var inputLineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	chatTextEdit = $Control/TextEdit
	inputLineEdit = $Control/LineEdit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_text_submit"):
		send_message()

func send_message():
	var message = inputLineEdit.text  # Get the message text
	if message != "":
		chatTextEdit.text += "\nYou: " + message
		inputLineEdit.text = ""  # Clear the input field
		chatTextEdit.scroll_vertical = INF # scroll the text to bottom
