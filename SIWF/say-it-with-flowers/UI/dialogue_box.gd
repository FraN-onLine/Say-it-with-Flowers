extends CanvasLayer

signal assemble_requested(entry_index: int)

@onready var portrait: TextureRect = $Portrait
@onready var name_label: Label = $Name
@onready var dialog_label: RichTextLabel = $Dialog

@onready var next_button: Button = $Next
@onready var assemble_button: Button = $Assemble
@onready var option_1: Button = $Option1
@onready var option_2: Button = $Option2

var dialogue_data: Array = []
var current_index: int = 0
var current_entry: Dictionary

func start(dialogue_array: Array, start_index := 0) -> void:
	dialogue_data = dialogue_array
	current_index = start_index
	_show_entry()

func _show_entry() -> void:
	if current_index < 0 or current_index >= dialogue_data.size():
		queue_free()
		return

	current_entry = dialogue_data[current_index]

	# Populate UI
	name_label.text = current_entry.get("name", "")
	dialog_label.text = current_entry.get("text", "")
	portrait.texture = current_entry.get("portrait", null)

	_update_buttons()

func _update_buttons() -> void:
	next_button.visible = false
	assemble_button.visible = false
	option_1.visible = false
	option_2.visible = false

	match current_entry.get("type", "dialogue"):
		"dialogue":
			next_button.visible = true

		"assemble":
			assemble_button.visible = true

		"option":
			option_1.visible = true
			option_2.visible = true

			option_1.text = current_entry.get("option_1_text", "Option 1")
			option_2.text = current_entry.get("option_2_text", "Option 2")

func _on_Next_pressed() -> void:
	_go_to_next(current_entry.get("next_entry_index", -1))

func _on_Assemble_pressed() -> void:
	assemble_requested.emit(current_index)

func _on_Option1_pressed() -> void:
	_select_option(0)

func _on_Option2_pressed() -> void:
	_select_option(1)

func _select_option(option_idx: int) -> void:
	var indices = current_entry.get("option_next_indices", [])
	if option_idx >= indices.size():
		return
	_go_to_next(indices[option_idx])

func _go_to_next(next_index: int) -> void:
	if next_index == -1:
		queue_free()
		return

	current_index = next_index
	_show_entry()
