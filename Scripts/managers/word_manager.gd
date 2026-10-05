extends Node2D

var words : Array[Word]
const WORD = preload("uid://cqk1rjw7rm52g")

func instance_word(value : Variant)-> void:
	var new_word : Word = WORD.instantiate()
	words.append(new_word)
	new_word.word = value	
	words.find(value)
	new_word.name = new_word.word
	
	add_child(new_word)
