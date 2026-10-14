class_name ItemManager
extends Node2D

var items : Array[Item]

func _ready() -> void:
	GameManager.item_manager = self

func find_word(word: Word) -> Item:
	var item : Item 
	
	for child in items:
		if child.own_word_name == word.word:
			item = child
	
	return item
