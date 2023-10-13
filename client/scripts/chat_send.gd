extends Control

var chatTextEdit
var inputLineEdit
var sync

# Called when the node enters the scene tree for the first time.
func _ready():
	#await get_tree().create_timer(2).timeout
	chatTextEdit = $TextEdit
	inputLineEdit = $LineEdit
	sync = $TextEdit/Sync

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_text_submit"):
		send_message()

func send_message():
	var message = inputLineEdit.text  # Get the message text
	if message != "":
		chatTextEdit.text += "\nYou: " + message
		sync.text = chatTextEdit.text
		inputLineEdit.text = ""  # Clear the input field
		chatTextEdit.scroll_vertical = INF # scroll the text to bottom
