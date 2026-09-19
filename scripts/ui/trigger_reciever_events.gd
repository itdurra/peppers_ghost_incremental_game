extends Area2D

@export var wishing_well_area: Area3D

@export var visual_effect_component: VisualEffectComponent
@export var sprite_hover_component: Node3DMouseEventComponent
@export var effect_component: EffectComponent

var is_colliding_with_mouse: bool = false

func _on_area_shape_exited(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	wishing_well_area.emit_signal("mouse_exited")
	is_colliding_with_mouse = false

func _on_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	wishing_well_area.emit_signal("mouse_entered")
	is_colliding_with_mouse = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_colliding_with_mouse:
			wishing_well_area.emit_signal("input_event", null, event, Vector3(0,0,0), Vector3(0,0,0), 0)

