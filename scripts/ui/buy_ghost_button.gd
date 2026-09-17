extends Button

#button for buying ghosts

class_name BuyGhostButton

@export var ghost_type: GhostEnum.GhostType
@export var player_res: PlayerResource
@export var ghost_res: GhostResource
@export var cooldown_bar: TextureProgressBar
@export var tween_time: float = .3

var cost: int
var level: int
var gname: String
var count: int

var t: Tween

func _ready() -> void:
	EventBus.connect("inventory_changed", _update_button)
	self._update_button()

#helper
#TODO: implement progress bar for being able to afford
func _check_enable_button() -> void:
	#disable/enable based on cost
	if player_res.has_enough_coins(cost):
		self.disabled = false
	else:
		self.disabled = true

	_update_cooldown()

func _update_cooldown() -> void:
	if !cooldown_bar:
		return
	
	var coins: int = player_res.get_coins()
	var decimal_percent_difference: float = float(coins) / float(cost)
	decimal_percent_difference *= 100

	var result_local: float
	if decimal_percent_difference > 100:
		result_local = 0
		_update_tween(result_local)
	else:
		result_local = 100 - decimal_percent_difference
		_update_tween(result_local)

	if result_local == 0:
		cooldown_bar.hide()
	else:
		cooldown_bar.show()

func _update_tween(value_local: float) -> void:
	if t:
		t.kill()

	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(cooldown_bar, "value", value_local, tween_time)

func _update_button() -> void:
	gname = ghost_res.get_ghost_name()
	cost = ghost_res.get_cost()
	level = ghost_res.get_level()
	count = ghost_res.get_count()

	if count >= (10 - 1):
		self.text = str(tr("PRESTIGE"))
	else:
		self.text = str(tr(gname))

	self._check_enable_button()

func _on_pressed() -> void:
	player_res.add_ghost(ghost_type) #this clears ghosts
	player_res.spend_coins(cost)
	self._update_button()
	EventBus.emit_spawn_ghost(ghost_type)
