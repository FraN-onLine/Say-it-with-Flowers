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
	"option_next_indices": null,

	#for assemble type only
	"success_entry_index": null,
	"failure_entry_index": null,
	"neutral_entry_index": null,
	#required flowers is an array of multiple arrays of 1-5 flowers that would be considered a success for this order
	"required_flowers": null,
	# unlock knowledge entry for a flower
	"unlock_knowledge": null # pass an index then global knowledge manager handles it
}
]

var dialogue = [
	{
		"name": "JOSA",
		"portrait": preload("res://Assets/Characters/Josa.png"),
		"text": "Ah! Granny Qi's old flower shop is open again., Oh hello there!",
		"type": "dialogue",
		"next_entry_index": 1
	},
	{
		"name": "JOSA",
		"portrait": preload("res://Assets/Characters/Josa.png"),
		"text": "You must be her grandchild. I've heard so much about you!",
		"type": "option",
		"option_1_text": "Yes, I am!",
		"option_2_text": "You know my grandmother?",
		"option_next_indices": [2, 3]
	},
	{
		"name": "JOSA",
		"portrait": preload("res://Assets/Characters/Josa.png"),
		"text": "Such enthusiasm! she also spares flowers for me when i stop by, ones that mean [b]happiness[/b]",
		"type": "dialogue",
		"next_entry_index": 4
	},
	{
		"name": "JOSA",
		"portrait": preload("res://Assets/Characters/Josa.png"),
		"text": "Well, i often stop by to chat with her. She spares [b]Tickseeds[/b] for me, what a sweet lady, She just knows how to make people feel special.",
		"type": "dialogue",
		"next_entry_index": 4
	},
	{
		"name": "JOSA",
		"portrait": preload("res://Assets/Characters/Josa.png"),
		"text": "Anyways i'm here to order flowers to show love! Oh? you don't know what to pick?",
		"type": "dialogue",
		"next_entry_index": 5
	},
	{
		"name": "JOSA",
		"portrait": preload("res://Assets/Characters/Josa.png"),
		"text": "then, [b]Red Chrysanthemums![/b] Assemble something special for me, will you?",
		"type": "assemble",
		"success_entry_index": 6,
		"failure_entry_index": 7,
		"neutral_entry_index": 8,
		"required_flowers": [ ["Red Chrysanthemum"] ],
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
