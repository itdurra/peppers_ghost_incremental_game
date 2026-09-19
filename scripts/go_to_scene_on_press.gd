extends Button

@export var target_path: String

func _on_pressed() -> void:
	get_tree().change_scene_to_file(target_path)
