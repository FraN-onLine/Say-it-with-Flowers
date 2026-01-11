extends TextureRect
class_name FlowerIcon

var flower_data: Flower

var home_parent: Node
var current_slot: Node = null

# Click / drag tracking
var _press_position: Vector2
var _dragging := false
const DRAG_THRESHOLD := 8


func _ready():
	home_parent = get_parent()


func setup(data: Flower) -> void:
	flower_data = data
	texture = data.texture


func _get_drag_data(_at_position: Vector2):
	_dragging = true

	var preview := TextureRect.new()
	preview.texture = texture
	preview.custom_minimum_size = size
	set_drag_preview(preview)

	return self


# Called when dropped somewhere INVALID
func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		_dragging = false
		if not get_parent():
			_return_to_home()


func _return_to_home():
	if current_slot:
		current_slot.current_flower = null
		current_slot = null

	if get_parent():
		get_parent().remove_child(self)

	home_parent.add_child(self)


func _gui_input(event):
	# Mouse pressed → record position
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT:

		if event.pressed:
			_press_position = event.position
			_dragging = false

		else:
			# Mouse released → treat as click ONLY if no drag happened
			if not _dragging and current_slot:
				_return_to_home()

	# Tooltip
	if event is InputEventMouseMotion:
		if flower_data.is_meaning_unlocked:
			tooltip_text = flower_data.name + " : " + flower_data.meaning
		else:
			tooltip_text = flower_data.name + " : ???"
