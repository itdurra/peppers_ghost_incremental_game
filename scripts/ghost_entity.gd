extends Node

#an entity for ghosts that tracks the level of ghost

class_name GhostEntity

@export var sprite_switcher_component: SpriteSwitcherComponent
@export var ghost_res: GhostResource

func setup() -> void:
	if !sprite_switcher_component:
		return

	sprite_switcher_component.switch_sprite()

	EventBus.connect("clear_ghost", _clear_ghost_node)


func is_same_type(type_local: GhostEnum.GhostType) -> bool:
	return ghost_res.get_ghost_type() == type_local

func _clear_ghost_node(ghost_type_local: GhostEnum.GhostType) -> void:
	if ghost_res.get_ghost_type() == ghost_type_local:
		if !self.is_queued_for_deletion():
			self.queue_free()
