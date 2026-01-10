extends CanvasLayer
class_name TextBox

signal assemble_requested(dialogue_data)
signal dialogue_finished
signal unlock_dictionary(entries: Array)

@onready var name_label: Label = $Name
@onready var dialogue_label: RichTextLabel = $Dialog
@onready var portrait_rect: TextureRect = $Portrait
@onready var assemble_button: Button = $Assemble
@onready var continue_button: Button = $Next

var dialogue_queue: Array = []
var current_data: Dictionary
var waiting_for_bouquet := false

func start(dialogue: Array) -> void:
	dialogue_queue = dialogue.duplicate()
	_show_next()

func _show_next() -> void:
	if dialogue_queue.is_empty():
		dialogue_finished.emit()
		queue_free()
		return

	current_data = dialogue_queue.pop_front()
	waiting_for_bouquet = false

	# Populate UI
	name_label.text = current_data.get("speaker", "")
	dialogue_label.text = current_data.get("text", "")
	portrait_rect.texture = current_data.get("portrait", null)

	# Unlock dictionary entries
	if current_data.has("unlock_flowers"):
		unlock_dictionary.emit(current_data["unlock_flowers"])

	# Assemble bouquet toggle
	if current_data.get("assemble_bouquet", false):
		assemble_button.visible = true
		continue_button.visible = false
	else:
		assemble_button.visible = false
		continue_button.visible = true

func _on_ContinueButton_pressed() -> void:
	if waiting_for_bouquet:
		return
	_show_next()

func _on_AssembleButton_pressed() -> void:
	waiting_for_bouquet = true
	assemble_requested.emit(current_data)
