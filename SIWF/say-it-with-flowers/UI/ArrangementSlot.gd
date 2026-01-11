extends Panel
class_name ArrangementSlot

var current_flower: FlowerIcon = null

func _can_drop_data(_pos, data) -> bool:
	return data is FlowerIcon


func _drop_data(_pos, data) -> void:
	var flower: FlowerIcon = data

	# Remove existing flower safely
	if current_flower:
		current_flower._return_to_home()

	# Re-parent dragged flower
	if flower.get_parent():
		flower.get_parent().remove_child(flower)

	add_child(flower)
	flower.position = (size - flower.size) / 2

	current_flower = flower
	flower.current_slot = self
