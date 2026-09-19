extends Area2D

@export var button: Button

var is_colliding_with_mouse: bool = false

func _on_area_shape_exited(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if button.disabled:
		return
	
	button.emit_signal("mouse_exited")
	button.release_focus()
	is_colliding_with_mouse = false

func _on_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if button.disabled:
		return
	
	button.emit_signal("mouse_entered")
	button.grab_focus()
	is_colliding_with_mouse = true

func _input(event: InputEvent) -> void:
	if button.disabled:
		return

	if event.is_action_pressed("interact"):
		if is_colliding_with_mouse:
			button.emit_signal("pressed")