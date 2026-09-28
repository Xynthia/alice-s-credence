extends Node2D

var words : Array[Word]
const WORD = preload("uid://cqk1rjw7rm52g")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#instance_word()
	#instance_word()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# if word gets on word then move word holding.





func instance_word(value : Variant)-> void:
	var new_word : Word = WORD.instantiate()
	words.append(new_word)
	new_word.word = value	
	words.find(value)
	new_word.name = new_word.word
	
	add_child(new_word)
