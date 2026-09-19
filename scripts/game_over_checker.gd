extends Node

#check if it's game over (all ghosts leveled)
#then switch to the game over scene

@export var ghosts: Array[GhostResource]
@export var target_scene_path: String

var duplicate_flag: bool = true

func _ready() -> void:
	EventBus.connect("inventory_changed", _check_game_over)

func _check_game_over() -> void:
	var is_game_over: bool = true

	for ghost in ghosts:
		if ghost.get_level() < Constants.MAX_INV - 1 && ghost.get_count() < Constants.MAX_INV:
			is_game_over = false
			break

	if is_game_over && duplicate_flag:
		duplicate_flag = false
		get_tree().change_scene_to_file(target_scene_path)
