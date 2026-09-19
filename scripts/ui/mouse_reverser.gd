extends Control

#use case: in this game the ipad is reflecting against a mirror, as a result
#everything in the game is displayed in reverse. Unfortunately this also
#reverses mouse-left and mouse-right motion. So this script creates a virtual
#cursor that moves left when the mouse moves right, and right for left. Also
#needs to interact with Control Nodes mouse-entered, mouse-exited, and click
#events

#custom cursor
@export var mouse_image: TextureRect
@export var click_tracker: TextureRect

var flag: bool = false

#simulate virtual cursor including mouse events
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#check every time the mouse is moved and pipe those coords to our
#custom cursor. Also reverse the x coords.
func _input(event: InputEvent) -> void:
	if !mouse_image:
		return
	if event is InputEventMouseMotion:
		reverse_x_coords_of_position(event)
	#if Input.is_action_just_pressed("interact"):
	#	simulate_click(event)

func reverse_x_coords_of_position(event: InputEventMouseMotion) -> void:
	if event.relative.is_zero_approx():
		return

	#set virtual cursor position
	mouse_image.position = Vector2(
		mouse_image.position.x + (-event.relative.x),
		mouse_image.position.y + event.relative.y
	)

	#set variables for a simulated mouse movement
	var mov_local: InputEventMouseMotion = InputEventMouseMotion.new()
	mov_local.device = event.device
	mov_local.position = mouse_image.position
	mov_local.relative = Vector2(-event.relative.x, event.relative.y)
	mov_local.velocity = Vector2(-event.velocity.x, event.velocity.y)
	#mov_local.global_position = mouse_image.global_position
	mov_local.screen_relative = Vector2(-event.screen_relative.x, event.screen_relative.y)
	mov_local.screen_velocity = Vector2(-event.screen_velocity.x, event.screen_velocity.y)

	click_tracker.position = mov_local.position
	#call mouse event
	Input.parse_input_event(mov_local)

#simulate click events for virtual mouse
func simulate_click(event: InputEvent) -> void:
	var button_local: InputEventMouseButton = InputEventMouseButton.new()
	button_local.button_index = MOUSE_BUTTON_LEFT
	button_local.pressed = true
	button_local.device = event.device
	button_local.position = mouse_image.position
	#button_local.global_position = mouse_image.global_position
	#button_local.relative = Vector2(-event.relative.x, event.relative.y)
	#button_local.velocity = Vector2(-event.velocity.x, event.velocity.y)

	#this flag prevents an infinite loop where event is never released
	if flag:
		Input.action_release("interact")
		flag = false			
		click_tracker.position = button_local.position
	else:
		Input.parse_input_event(button_local)
		flag = true
