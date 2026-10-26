class_name ItemManager
extends Node2D

var items : Array[Item]

@onready var bed: Item = $bed
@onready var cabinet: Item = $Cabinet
@onready var door: Item = $door
@onready var plant: Item = $plant
@onready var cabinet_2: Item = $cabinet2
@onready var picture: Item = $picture

var has_clothes : bool = false


func _ready() -> void:
	GameManager.item_manager = self

func find_word(word: Word) -> Item:
	var item : Item 
	
	for child in items:
		if child.own_word_name == word.word:
			item = child
	
	return item

func change_cabinet() -> void:
	cabinet.truthfull_dialog = cabinet_2.truthfull_dialog
	cabinet.half_truthfull_dialog = cabinet_2.half_truthfull_dialog
	cabinet.not_truthfull_dialog = cabinet_2.not_truthfull_dialog
	cabinet.item_to_give = cabinet_2.item_to_give
