extends Node

class_name EffectComponent

#effect component, called on collision

@export var player_res: PlayerResource 
@export var ghost_res: GhostResource
@export var reciever_res: RecieverResource

func add_coins(_area: Area3D) -> void:
	if !ghost_res:
		return

	var amount_local: int = ghost_res.get_effect_amount()
	player_res.add_coins(amount_local)

func add_water(_area: Area3D) -> void:
	if !ghost_res:
		return

	var amount_local: int = ghost_res.get_effect_amount()
	player_res.add_water(amount_local)

func _on_area_3d_input_event(
	_camera: Node, 
	event: InputEvent, 
	_event_position: Vector3,
	_normal: Vector3, 
	_shape_idx: int
) -> void:
	if !reciever_res:
		return

	if event.is_action_pressed("interact"):
		var amount_local: int = reciever_res.get_effect_amount()
		player_res.add_coins(amount_local)
