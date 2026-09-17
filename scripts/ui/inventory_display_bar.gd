extends HBoxContainer

#loop through sprites and set to empty image or a target sprite
#based on inventory from player resource

@export var ghost_res: GhostResource
@export var empty_image: CompressedTexture2D

#will always be length 10
@export var sprite_arr: Array[TextureRect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("inventory_changed", _update_inventory)

	self._update_inventory()

func _update_inventory() -> void:
	var count_local = ghost_res.get_count()
	var count: int = 0

	for sprite in sprite_arr:
		if count_local >= (count + 1):
			sprite_arr[count].texture = ghost_res.get_sprite()
		else:
			sprite_arr[count].texture = empty_image
		count += 1
	
	%level_label.text = str(
		"LEVEL ",
		ghost_res.get_level()
	)