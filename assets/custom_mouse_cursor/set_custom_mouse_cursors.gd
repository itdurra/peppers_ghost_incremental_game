extends Node

#handles updating custom mouse cursors
#enum documented here: https://docs.godotengine.org/en/stable/classes/class_input.html#enum-input-cursorshape

@export var arrow: CompressedTexture2D
@export var point: CompressedTexture2D

func _ready():
	if !arrow || !point:
		if OS.is_debug_build():
			push_error("vars not set")
		return

	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(point, Input.CURSOR_POINTING_HAND)