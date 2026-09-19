extends Control

# The iPad is reflected against a mirror, so the game is displayed
# horizontally reversed. We therefore create a virtual mouse cursor
# whose X movement is opposite to the physical mouse movement.
#
# The important part is that we also warp the actual viewport mouse
# position to the virtual cursor position. This allows normal Control
# nodes to continue receiving:
#
#   mouse_entered
#   mouse_exited
#   gui_input
#   button_pressed / button_down / button_up
#
# without modifying those Controls.

@export var mouse_image: TextureRect
@export var click_tracker: TextureRect

var virtual_mouse_position: Vector2


var flag: bool = false


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Start virtual cursor at the center of the viewport.
	virtual_mouse_position = get_viewport_rect().size / 2.0

	_update_virtual_cursor()
	_warp_real_mouse()


func _input(event: InputEvent) -> void:
	if not mouse_image:
		return

	if event is InputEventMouseMotion:
		_handle_mouse_motion(event)

	elif event is InputEventMouseButton:
		_handle_mouse_button(event)


# ---------------------------------------------------------
# MOUSE MOVEMENT
# ---------------------------------------------------------

func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if event.relative.is_zero_approx():
		return

	# Reverse X movement.
	virtual_mouse_position.x -= event.relative.x
	virtual_mouse_position.y += event.relative.y

	# Keep virtual cursor inside the viewport.
	virtual_mouse_position.x = clamp(
		virtual_mouse_position.x,
		0.0,
		get_viewport_rect().size.x
	)

	virtual_mouse_position.y = clamp(
		virtual_mouse_position.y,
		0.0,
		get_viewport_rect().size.y
	)

	_update_virtual_cursor()

	# Make Godot's GUI system think the mouse is actually here.
	_warp_real_mouse()


func _update_virtual_cursor() -> void:
	mouse_image.position = virtual_mouse_position - mouse_image.size / 2.0


func _warp_real_mouse() -> void:
	get_viewport().warp_mouse(virtual_mouse_position)


# ---------------------------------------------------------
# MOUSE BUTTON
# ---------------------------------------------------------

func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	# The physical mouse button event has already reached _input.
	#
	# Its position is NOT the virtual position, so create a new
	# mouse event using the virtual cursor position.
	var virtual_event := InputEventMouseButton.new()

	virtual_event.device = event.device
	virtual_event.button_index = MOUSE_BUTTON_LEFT
	virtual_event.pressed = event.pressed
	virtual_event.double_click = event.double_click
	virtual_event.factor = event.factor
	virtual_event.position = virtual_mouse_position

	if flag:
		# Send the event through Godot's normal input system.
		Input.action_release("interact")
		flag = false			
		click_tracker.position = event.position
	else:
		Input.parse_input_event(virtual_event)
		flag = true