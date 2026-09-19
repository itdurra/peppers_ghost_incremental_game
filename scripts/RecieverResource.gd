class_name RecieverResource extends Resource

@export_category("change these")
@export var reciever_name: String = "Wishing Well"
@export var reciever_type: RecieverEnum.RecieverType = RecieverEnum.RecieverType.WishingWell
@export var sprite_dict: Dictionary[int, CompressedTexture2D] #level mapped to sprite
@export var base_effect: int = 10
@export var effect_mult: float = 1.1
@export var base_cost: int = 10
@export var cost_mult: float = 1.25

@export_category("leave these")
@export var count: int = 0
@export var level: int = 0
@export var cost: int = 0

func is_same_reciever_type(reciever_type_local: RecieverEnum.RecieverType) -> bool:
	return reciever_type == reciever_type_local

func get_sprite() -> CompressedTexture2D:
	return sprite_dict[level + 1]

func get_count() -> int:
	return count

func reset_count() -> void:
	count = 0

func get_level() -> int:
	return level

func get_reciever_type() -> RecieverEnum.RecieverType:
	return reciever_type

func get_effect_amount() -> int:
	#get cost
	var effect_local = int(
		base_effect #base req for level 2
		* effect_mult #mult
		* ((level * Constants.MAX_INV) + count) #next level - 1
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

func buy_reciever() -> void:
	if self.get_count() >= Constants.MAX_INV:
		self.reset_count()
		self.increment_level()
		EventBus.emit_clear_reciever(self.get_reciever_type())
	else:
		self.increment_count()

func get_reciever_name() -> String:
	return reciever_name

func increment_level() -> void:
	level += 1
	EventBus.emit_inventory_changed()

func increment_count() -> void:
	count += 1
	EventBus.emit_inventory_changed()
