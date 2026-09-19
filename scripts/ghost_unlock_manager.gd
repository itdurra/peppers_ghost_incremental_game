extends Node

@export var player_res: PlayerResource
@export var ghosts: Array[GhostResource] #needs to be in order of unlocks

@export var inventory_display: Control
@export var progress_bar: Control
@export var purchase_menu: Control

@export var tween_time: float = 1.3

var has_clicked: bool = false

var t: Tween
var t2: Tween
var t3: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory_display.modulate = Color(0, 0, 0, 0)
	progress_bar.modulate = Color(0, 0, 0, 0)
	purchase_menu.modulate = Color(0, 0, 0, 0)
	EventBus.connect("inventory_changed", _check_has_clicked)

#should call tween in progress bar if hasn't clicked (gained coisn)
#then calls check unlock methods
func _check_has_clicked() -> void:
	if player_res.get_coins() > 0:
		if !has_clicked:
			has_clicked = true
			tween_in_progress()

	_check_unlock_first()

func _check_unlock_first() -> void:
	#if unlocked skip this method
	if( 
		ghosts[0].get_is_available() && 
		ghosts[0].get_level() >= 1 
	):
		self._check_unlock_remaining()

	#if not enough coins to afford return
	if player_res.get_coins() < ghosts[0].get_cost():
		return
	else: #unlock
		ghosts[0].set_is_available(true)
		tween_in_inventory()
		tween_in_purchase()
	
#check unlocks for remaining ghosts
func _check_unlock_remaining() -> void:
	var count: int = 0

	for ghost in ghosts:
		count += 1
		
		#skip first already unlocked
		if count == 1:
			continue

		#if unlocked keep going
		if ghost.get_is_available():
			if ghost.get_level() >= 1:
				continue
			else:
				break
		else: #else set available and break
			ghost.set_is_available(true)
			break

# tween methods, seperated b/c may have unique behavior

func tween_in_inventory() -> void:
	if t:
		return

	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(inventory_display, "modulate", Color(1,1,1,1), tween_time)

func tween_in_progress() -> void:
	if t2:
		return

	t2 = create_tween()
	t2.set_trans(Tween.TRANS_CUBIC)
	t2.set_ease(Tween.EASE_IN_OUT)
	t2.tween_property(progress_bar, "modulate", Color(1,1,1,1), tween_time)

func tween_in_purchase() -> void:
	if t3:
		return

	t3 = create_tween()
	t3.set_trans(Tween.TRANS_CUBIC)
	t3.set_ease(Tween.EASE_IN_OUT)
	t3.tween_property(purchase_menu, "modulate", Color(1,1,1,1), tween_time)
