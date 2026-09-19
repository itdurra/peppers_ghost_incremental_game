extends Node

class_name Node3DMouseEventComponent

#for increasing size when hovering over Node3D

@export var pivot: Node3D
@export var origin: Node3D
@export var target_scale: Vector3 = Vector3(1.2, 1.2, 1.2)
@export var return_scale: Vector3 = Vector3(1, 1, 1)
@export var time: float = .3
@export var shake_offset: Vector3 = Vector3(0, .03, 0)
@export var shake_duration: float = .3

var t: Tween

#mouse enter, change mouse cursor
func _on_area_3d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

	if t:
		t.kill()

	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(pivot, "scale", target_scale, .3)

#mouse exit, change cursor
func _on_area_3d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

	if t:
		t.kill()

	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(pivot, "scale", return_scale, .3)

#onclick
func _on_area_3d_input_event(
	_camera: Node,
	event: InputEvent, 
	_event_position: Vector3, 
	_normal: Vector3, 
	_shape_idx: int
) -> void:
	if event.is_action_pressed("interact"):
		if t:
			t.kill()
		t = self.create_tween()

		t.set_trans(Tween.TRANS_BOUNCE)
		t.set_ease(Tween.EASE_IN_OUT)

		t.tween_property(self.origin, "position", shake_offset, shake_duration)
		t.tween_property(self.origin, "position", Vector3(0,0,0), shake_duration)
