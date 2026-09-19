extends Control

#exp bar

@export var progress_bar: ProgressBar
@export var player_res: PlayerResource

@export var level_value: Label
@export var exp_value: Label
@export var exp_req_value: Label
@export var coin_value: Label
@export var water_value: Label

@export var level_up_effect: GPUParticles2D

func _ready() -> void:
	EventBus.connect("inventory_changed", _update_exp)

	_update_exp()

#update UI:
#TODO: add tweens on every update
func _update_exp() -> void:

	#update progres bar
	if !player_res || !progress_bar:
		return

	progress_bar.value = player_res.get_experience()
	progress_bar.max_value = player_res.get_exp_required()

	#update text labels
	if !level_value || !coin_value || !water_value:
		return

	#check if we leveled up
	var temp_level: int = player_res.get_level()
	if int(level_value.text) != temp_level:
		level_up_effect.emitting = true

	#set vars
	level_value.text = str(temp_level)
	coin_value.text = str(player_res.get_coins())
	water_value.text = str(player_res.get_water())

	#update text labels
	if !exp_value || !exp_req_value:
		return

	exp_value.text = str(player_res.get_experience())
	exp_req_value.text = str(player_res.get_exp_required())
