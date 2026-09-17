extends Node

#spawn signals
signal spawn_ghost(type_local: GhostEnum.GhostType)
signal spawn_reciever(type_local: RecieverEnum.RecieverType)

#remove signals
signal clear_ghost(type_local: GhostEnum.GhostType)
signal clear_reciever(type_local: RecieverEnum.RecieverType)

#add inventory methods
signal inventory_changed()

#------------------ spawners

func emit_spawn_ghost(type_local: GhostEnum.GhostType) -> void:
	emit_signal("spawn_ghost", type_local)

func emit_spawn_reciever(type_local: RecieverEnum.RecieverType) -> void:
	emit_signal("spawn_reciever", type_local)

func emit_clear_ghost(type_local: GhostEnum.GhostType) -> void:
	emit_signal("clear_ghost", type_local)

func emit_clear_reciever(type_local: RecieverEnum.RecieverType) -> void:
	emit_signal("clear_reciever", type_local)

#------------------ inventory changed update UI

func emit_inventory_changed() -> void:
	emit_signal("inventory_changed")