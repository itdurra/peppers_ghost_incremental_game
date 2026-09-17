class_name EntityScenesResource extends Resource

@export var ghost_scene_dict: Dictionary[GhostEnum.GhostType, PackedScene]
@export var reciever_scene_dict: Dictionary[RecieverEnum.RecieverType, PackedScene]

#used by spawner to reach into ghost resources 
# and get a packed scene
func get_ghost_scene(ghost_type_local: GhostEnum.GhostType) -> PackedScene:
	return ghost_scene_dict[ghost_type_local]

#used by spawner to reach into ghost resources 
# and get a packed scene
func get_reciever_scene(reciever_type_local: RecieverEnum.RecieverType) -> PackedScene:
	return reciever_scene_dict[reciever_type_local]