extends HBoxContainer

@export var ghost_res: GhostResource
@export var ghost_type: GhostEnum.GhostType
@export var player_res: PlayerResource
@export var coin_path: CompressedTexture2D #coin image
@export var cooldown_bar: TextureProgressBar
@export var buy_button: Button
@export var price_label: RichTextLabel
@export var tween_time: float = .3

#tween vars
@export var hbox_tween_start: Vector2 = Vector2(-900, 0)
@export var hbox_tween_time: float = 1.3

var cost: int
var level: int
var gname: String
var count: int
var effect: int
var texture: CompressedTexture2D

var t: Tween
var t2: Tween
var t3: Tween
var is_tweened_in: bool = false
var is_maxxed_out: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.offset_transform_position = hbox_tween_start
	EventBus.connect("inventory_changed", _router)
	_update_price()
	self._update_button()

func _router() -> void:
	self._update_inventory()
	self._update_price()
	self._update_button()
	self._check_tween_off()

func _check_tween_off() -> void:
	if (
		ghost_res.get_count() >= Constants.MAX_INV && 
		ghost_res.get_level() >= Constants.MAX_INV
	):
		is_maxxed_out = true
		self.hbox_tween_off()

#helper
#TODO: implement progress bar for being able to afford
func _check_enable_button() -> void:
	#disable/enable based on cost
	#and needs to be on the screen (tweened in)
	if player_res.has_enough_coins(cost) && is_tweened_in && !is_maxxed_out:
		buy_button.disabled = false
	else:
		buy_button.disabled = true

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
	effect = ghost_res.get_effect_amount()
	texture = ghost_res.get_sprite()

	buy_button.icon = texture

	if count >= (Constants.MAX_INV):
		buy_button.text = str(tr("PRESTIGE"))
	else:
		var rate: int = (
			effect * (count + (level * Constants.MAX_INV))
		)

		if rate == 0:
			buy_button.text = str(tr(gname))
		else:
			#removing rate display to make UI bigger
			##buy_button.text = str(tr(gname), " +", rate ,"/s")
			buy_button.text = str(tr(gname))

	self._check_enable_button()

func _on_pressed() -> void:
	player_res.add_ghost(ghost_type) #this clears ghosts
	player_res.spend_coins(cost)
	self._update_button()
	EventBus.emit_spawn_ghost(ghost_type)

func tween_in() -> void:
	if t:
		return

	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(buy_button, "offset_transform_position", Vector2(0,0), tween_time)

func _update_inventory() -> void:
	#if ghost is ready, and hbox is not tweened in yet
	if ghost_res.get_is_available() && !is_tweened_in:
		is_tweened_in = true
		hbox_tween_in()

func _update_price() -> void:
	price_label.text = str(
		"[img]",
		coin_path.resource_path,
		"[/img]",
		ghost_res.get_cost()
	)

func hbox_tween_in() -> void:
	if t2:
		return

	t2 = create_tween()
	t2.set_trans(Tween.TRANS_CUBIC)
	t2.set_ease(Tween.EASE_IN_OUT)
	t2.tween_property(self, "offset_transform_position", Vector2(0,0), hbox_tween_time)

#for when ghost is maxed out
func hbox_tween_off() -> void:
	if t3:
		return

	t3 = create_tween()
	t3.set_trans(Tween.TRANS_CUBIC)
	t3.set_ease(Tween.EASE_IN_OUT)
	t3.tween_property(self, "offset_transform_position", hbox_tween_start, hbox_tween_time)