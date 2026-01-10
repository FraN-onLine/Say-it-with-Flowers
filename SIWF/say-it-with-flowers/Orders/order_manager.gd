extends Node

#in orders, omit the ones unnecessary for the dialogue
var order_sample = [
{
	"name": "JOSA",
	"portrait": preload("res://Assets/Characters/Josa.png"),
	"text": "I want to apologize… but gently.",
	
	# type: "dialogue", "assemble", "option"
	"type": "dialogue",

	# For dialogue / assemble
	"next_entry_index": 1,

	# For option type only
	"option_1_text": null,
	"option_2_text": null,
	"option_next_indices": null
}
]

var dialogue = [
	{
		"name": "JOSA",
		"portrait": preload("res://Assets/Characters/Josa.png"),
		"text": "I haven’t been here in a while.",
		"type": "dialogue",
		"next_entry_index": 1
	},
	{
		"name": "JOSA",
		"text": "Your grandma always knew what to say.",
		"type": "dialogue",
		"next_entry_index": 2
	},
	{
		"text": "Could you help me say it?",
		"type": "assemble"
	},
	{
		"text": "Thank you… this feels right.",
		"type": "dialogue",
		"next_entry_index": -1
	},
	{
		"text": "This isn’t what I meant.",
		"type": "dialogue",
		"next_entry_index": -1
	}
]

func _ready():
	await get_tree().process_frame
	get_tree().get_first_node_in_group("dialog_box").start(dialogue)
