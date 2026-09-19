class_name PlayerResource extends Resource

@export var coins: int = 0
@export var water: int = 0
@export var level: int = 0
@export var experience: int = 0
@export var exp_required: int = 20

@export var base_exp: int = 100
@export var exp_mult: float = 1.25

#inventory dictionary for ghosts
@export var ghosts: Array[GhostResource]
@export var recievers: Array[RecieverResource]

#--------------getters--------------#

func get_coins() -> int:
	return self.coins

func get_water() -> int:
	return self.water

func get_level() -> int:
	return self.level

func get_experience() -> int: 
	return self.experience

func get_exp_required() -> int:
	return self.exp_required

func get_ghosts() -> Array[GhostResource]:
	return ghosts

func get_recievers() -> Array[RecieverResource]:
	return recievers

#-----------------setters -----------------------#

func set_coins(value_local: int) -> void:
	if value_local <= 0:
		value_local = 0

	self.coins = value_local

	self._notify_inventory()

func set_water(value_local: int) -> void:
	if value_local <= 0:
		value_local = 0

	self.water = value_local

	self._notify_inventory()

func set_level(value_local: int) -> void:
	if value_local <= 1:
		value_local = 1

	self.level = value_local

	self._notify_inventory()

func set_experience(value_local: int) -> void:
	if value_local <= 0:
		value_local = 0

	self.experience = value_local

	self._notify_inventory()

func set_exp_required(value_local: int) -> void:
	if value_local <= 0:
		value_local = 0

	self.exp_required = value_local

	self._notify_inventory()

#------------------ inventory --------------------#

#central method for adding coins
#increases with player level as well
func add_coins(value_local: int) -> void:
	if value_local <= 0:
		return

	self.set_coins((value_local * self.get_level()) + self.get_coins())
	self.add_exp(value_local)

	self._notify_inventory()

func add_water(value_local: int) -> void:
	if value_local <= 0:
		return

	self.set_water(value_local + self.get_water())
	self.add_exp(value_local)

	self._notify_inventory()

#recursive to handle level ups
func add_exp(value_local: int) -> void:
	if value_local <= 0:
		return

	#reduce amount of exp gain
	@warning_ignore("integer_division")
	value_local = int(value_local / 10) + 1

	var temp_rem_exp: int
	var temp_new_exp: int = value_local + self.get_experience()
	if temp_new_exp >= self.get_exp_required():
		temp_rem_exp = (
			value_local - (
				self.get_exp_required() - self.get_experience()
			)
		)
		self.next_level()
		self.add_exp(temp_rem_exp)
	else:
		self.set_experience(value_local + self.get_experience())

	self._notify_inventory()

func spend_coins(value_local: int) -> void:
	if value_local <= 0:
		return

	self.set_coins(self.get_coins() - value_local)

	self._notify_inventory()

func has_enough_coins(value_local: int) -> bool:
	return self.get_coins() >= value_local

#---------------------- Dictionary Methods ------------------#
func add_ghost(gt_local: GhostEnum.GhostType) -> void:
	for ghost in ghosts:
		if ghost.get_ghost_type() == gt_local:
			ghost.buy_ghost()

			self._notify_inventory()

func add_reciever(rt_local: RecieverEnum.RecieverType) -> void:
	for reciever in recievers:
		if reciever.get_reciever_type() == rt_local:
			reciever.buy_reciever()

			self._notify_inventory()

#--------------incrementers-------------------#

#exponential level curve
func next_level() -> void:
	self.set_level(self.get_level() + 1)

	var temp_exp_required = int(
		base_exp #base req for level 2
		* exp_mult #mult
		* self.get_level() #next level - 1
	)
	self.set_exp_required(temp_exp_required)
	self.set_experience(0)
	
	self._notify_inventory()


#-------------helper ---------------------#

func _notify_inventory() -> void:
	EventBus.emit_inventory_changed()

