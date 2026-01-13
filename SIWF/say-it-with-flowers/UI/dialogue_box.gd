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


# =========================
# ADD: Typing effect config
# =========================
@export var typing_speed := 0.03 # seconds per character

var _full_text: String = ""
var _typing := false
var _typing_tween: Tween


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

	# ADD: start typing instead of instant text
	_start_typing(current_entry.get("text", ""))

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


# =========================
# ADD: Typing effect logic
# =========================
func _start_typing(text: String) -> void:
	if _typing_tween and _typing_tween.is_running():
		_typing_tween.kill()

	_full_text = text
	dialog_label.text = ""
	_typing = true

	_typing_tween = create_tween()
	for i in _full_text.length():
		_typing_tween.tween_callback(
			func():
				dialog_label.text += _full_text[i]
		).set_delay(typing_speed)

	_typing_tween.tween_callback(_finish_typing)



func _finish_typing() -> void:
	_typing = false
	dialog_label.text = _full_text


func _set_buttons_disabled(disabled: bool) -> void:
	next_button.disabled = disabled
	assemble_button.disabled = disabled
	option_1.disabled = disabled
	option_2.disabled = disabled


func _skip_typing_if_needed() -> bool:
	if _typing:
		if _typing_tween:
			_typing_tween.kill()
		_finish_typing()
		return true
	return false


# =========================
# Button callbacks (extended)
# =========================
func _on_Next_pressed() -> void:
	if _skip_typing_if_needed():
		return
	_go_to_next(current_entry.get("next_entry_index", -1))


func _on_Assemble_pressed() -> void:
	if _skip_typing_if_needed():
		return

	var assemble_scene := preload("res://UI/AssembleMenu.tscn").instantiate()
	get_tree().current_scene.add_child(assemble_scene)

	assemble_scene.assemble_finished.connect(
		func(result: String):
			var next_index = current_entry.get(result, -1)
			_go_to_next(next_index)
	)



func _on_Option1_pressed() -> void:
	if _skip_typing_if_needed():
		return
	_select_option(0)


func _on_Option2_pressed() -> void:
	if _skip_typing_if_needed():
		return
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
