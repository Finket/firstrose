extends TextEdit

func _on_text_changed():
	var sync = $Sync
	sync.text = text
	#if is_multiplayer_authority():
	#	sync.text = text

func _process(_delta):
	var sync = $Sync
	text = sync.text
	#if not is_multiplayer_authority():
	#	text = sync.text
