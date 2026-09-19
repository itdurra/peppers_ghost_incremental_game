extends HBoxContainer

#loop through sprites and set to empty image or a target sprite
#based on inventory from player resource

@export var ghost_res: GhostResource
@export var empty_image: CompressedTexture2D

#tween vars
@export var tween_start: Vector2 = Vector2(-600, 0)
@export var tween_time: float = 1.3

var t: Tween
var is_tweened_in: bool = false

#will always be length MAX_INV
@export var sprite_arr: Array[TextureRect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.offset_transform_position = tween_start

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
		"L",
		ghost_res.get_level()
	)

	#if ghost is ready, and hbox is not tweened in yet
	if ghost_res.get_is_available() && !is_tweened_in:
		is_tweened_in = true
		tween_in()

func tween_in() -> void:
	if t:
		return

	t = create_tween()
	t.set_trans(Tween.TRANS_CUBIC)
	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(self, "offset_transform_position", Vector2(0,0), tween_time)
