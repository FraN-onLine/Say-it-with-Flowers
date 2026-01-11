extends Panel
class_name ArrangementSlot

var current_flower: FlowerIcon = null

func _can_drop_data(_pos, data) -> bool:
	return data is FlowerIcon

func _drop_data(_pos, data) -> void:
	if current_flower:
		current_flower.queue_free()

	current_flower = data

	data.get_parent().remove_child(data)
	add_child(data)

	data.position = (size - data.size) / 2
