class_name GhostResource extends Resource

#a container for ghosts data

@export_category("set_these")
@export var ghost_name: String = "Ghost"
@export var ghost_type: GhostEnum.GhostType = GhostEnum.GhostType.Ghost
@export var ghost_names: Array[String]
@export var sprite_dict: Dictionary[int, CompressedTexture2D] #level mapped to sprite
@export var base_effect: int = 10
@export var base_cost: int = 10
@export var effect_mult: float = 1.1
@export var cost_mult: float = 1.25
@export var is_available: bool = false

@export_category("leave_these")
@export var count: int = 0
@export var level: int = 0
@export var cost: int = 0

func is_same_ghost_type(ghost_type_local: GhostEnum.GhostType) -> bool:
	return ghost_type == ghost_type_local

func get_sprite() -> CompressedTexture2D:
	if level + 1 > Constants.MAX_INV:
		return sprite_dict[Constants.MAX_INV]

	return sprite_dict[level + 1]

func get_count() -> int:
	return count

func reset_count() -> void:
	count = 0
	EventBus.emit_inventory_changed()

func get_level() -> int:
	return level

func get_ghost_type() -> GhostEnum.GhostType:
	return ghost_type

func get_is_available() -> bool:
	return is_available

func set_is_available(value_local: bool) -> void:
	is_available = value_local

func get_effect_amount() -> int:
	#get cost
	var effect_local = int(
		base_effect #base req for level 2
		* effect_mult #mult
		* level #next level - 1
	)

	if effect_local == 0:
		return base_effect

	return effect_local

func get_cost() -> int:
	#get cost
	var cost_local = int(
		base_cost #base req for level 2
		* cost_mult #mult
		* ((level * Constants.MAX_INV) + count) #next level - 1
	)

	if cost_local == 0:
		return base_cost

	return cost_local

func buy_ghost() -> void:
	if self.get_count() >= (Constants.MAX_INV):
		if self.level >= Constants.MAX_INV: #game over
			return
		self.reset_count()
		self.increment_count()
		self.increment_level()
		EventBus.emit_clear_ghost(self.get_ghost_type())
	else:
		self.increment_count()

func get_ghost_name() -> String:
	return ghost_name

func increment_level() -> void:
	level += 1
	#change name depending on level
	if level <= Constants.MAX_INV:
		ghost_name = ghost_names[level - 1]
	EventBus.emit_inventory_changed()

func increment_count() -> void:
	count += 1
	EventBus.emit_inventory_changed()
