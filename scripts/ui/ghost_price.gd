extends RichTextLabel

@export var path: CompressedTexture2D
@export var ghost_res: GhostResource

func _ready() -> void:
	EventBus.connect("inventory_changed", _update_price)
	_update_price()

func _update_price() -> void:
	self.text = str(
		"[img]",
		path.resource_path,
		"[/img]",
		ghost_res.get_cost()
	)