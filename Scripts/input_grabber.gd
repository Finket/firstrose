extends TextureRect

signal click_captured(event : InputEvent)

func _gui_input(event : InputEvent) -> void:
	click_captured.emit(event)
