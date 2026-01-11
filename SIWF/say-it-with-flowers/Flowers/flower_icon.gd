extends TextureRect
class_name FlowerIcon

var flower_data: Flower
var original_parent: Node
var original_position: Vector2

func setup(data: Flower) -> void:
	flower_data = data
	texture = data.texture

func _get_drag_data(_at_position: Vector2):
	var preview := TextureRect.new()
	preview.texture = texture
	preview.custom_minimum_size = size
	set_drag_preview(preview)

	original_parent = get_parent()
	original_position = position

	return self

func _can_drop_data(_at_position: Vector2, _data) -> bool:
	return false
