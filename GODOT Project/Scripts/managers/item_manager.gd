class_name ItemManager
extends Node2D

var items : Array[Item]

@onready var bed: Item = $bed
@onready var cabinet: Item = $cabinet
@onready var door: Item = $door
@onready var plant: Item = $plant
@onready var cabinet_2: Item = $cabinet2
@onready var picture: Item = $picture
@onready var box: Item = $box
@onready var case_file: Item = $"case file"
@onready var shoes: Item = $shoes
@onready var clothes: Item = $clothes
@onready var police_badge: Item = $"police badge"
@onready var pipe: Item = $pipe
@onready var calender: Item = $calender
@onready var lamp: Item = $lamp
@onready var broken_lamp: Item = $"broken lamp"

var has_clothes : bool = false


func _ready() -> void:
	GameManager.item_manager = self

func reset() -> void:
	for child in items:
		child.has_been_given = false
		child.has_been_looked_at = false
		

func find_word(word: Word) -> Item:
	var item : Item 
	
	for child in items:
		if child.own_word_name == word.word:
			item = child
	
	return item

func change_cabinet() -> void:
	cabinet.dialogue_cue = cabinet_2.dialogue_cue
	cabinet.item_to_give = cabinet_2.item_to_give
