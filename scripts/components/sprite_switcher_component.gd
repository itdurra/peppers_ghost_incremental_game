extends Node

class_name SpriteSwitcherComponent

#switches sprites based on a provided level variable

@export var visual_sprite: Sprite3D
@export var res: Resource

func switch_sprite() -> void:
	if visual_sprite:
		handle_sprite3D()

func handle_sprite3D() -> void:	
	var tex_local: CompressedTexture2D = res.get_sprite()
	visual_sprite.texture = tex_local
