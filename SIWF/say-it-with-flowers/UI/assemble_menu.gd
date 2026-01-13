extends CanvasLayer

signal assemble_finished(result: String)

@export var expected_arrangement: Array = []

@onready var flower_list: VBoxContainer = $Flower_Box/FlowerList
@onready var arrangement_slots := [
	$Arrangement1,
	$Arrangement2,
	$Arrangement3,
	$Arrangement4,
	$Arrangement5
]

var current_arrangement: Array = []

const FLOWER_ICON_SCENE := preload("res://Flowers/flower_icon.tscn")

func _ready() -> void:
	_load_unlocked_flowers()

func _load_unlocked_flowers() -> void:
	#delete all children first
	for child in flower_list.get_children():
		child.queue_free()

	for path in KnowledgeManager.unlocked_flowers:
		var flower_data = load(path)
		if flower_data == null:
			continue

		var icon: FlowerIcon = FLOWER_ICON_SCENE.instantiate()
		icon.setup(flower_data)

		flower_list.add_child(icon)

func get_current_arrangement() -> Array:
	current_arrangement.clear()

	for slot in arrangement_slots:
		if slot.current_flower:
			current_arrangement.append(slot.current_flower.flower_data.id)
		else:
			current_arrangement.append(null)

	return current_arrangement

func evaluate_arrangement() -> String:
	var current := get_current_arrangement()

	if current == expected_arrangement:
		return "success"

	var correct := 0
	for i in current.size():
		if current[i] != null and current[i] == expected_arrangement[i]:
			correct += 1

	if correct == 0:
		return "fail"

	return "neutral"

func _on_Assemble_pressed() -> void:
	var result := evaluate_arrangement()
	assemble_finished.emit(result)
	queue_free()
