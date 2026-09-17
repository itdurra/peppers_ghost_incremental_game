extends Node

#instantiate ghost objects to a spawn point, stored as packed scenes

class_name EntitySpawner

#ghosts:
@export var scene_res: EntityScenesResource
@export var spawn_point: Node3D

func _ready() -> void:
	EventBus.connect("spawn_ghost", _spawn_ghost)
	EventBus.connect("spawn_reciever", _spawn_reciever)

func _spawn_ghost(type_local: GhostEnum.GhostType) -> void:
	var ghost_scene: PackedScene = scene_res.get_ghost_scene(type_local)
	var node: Node = ghost_scene.instantiate()
	node.setup()
	spawn_point.add_child(node)

func _spawn_reciever(type_local: RecieverEnum.RecieverType) -> void:
	var reciever_scene: PackedScene = scene_res.get_reciever_scene(type_local)
	var node: Node = reciever_scene.instantiate()
	node.setup()
	spawn_point.add_child(node)

	

	
