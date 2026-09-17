extends Node

#an entity for recievers that tracks the level of reciever

class_name RecieverEntity

@export var reciever_res: RecieverResource
@export var sprite_switcher_component: SpriteSwitcherComponent

func setup() -> void:
	if !sprite_switcher_component:
		return

	sprite_switcher_component.switch_sprite()
	EventBus.connect("clear_reciever", _clear_reciever_node)

func is_same_type(type_local: RecieverEnum.RecieverType) -> bool:
	return reciever_res.get_reciever_type() == type_local

func _clear_reciever_node(reciever_type_local: RecieverEnum.RecieverType) -> void:
	if reciever_res.get_reciever_type() == reciever_type_local:
		if !self.is_queued_for_deletion():
			self.queue_free()