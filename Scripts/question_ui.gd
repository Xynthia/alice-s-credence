class_name QuestionUI
extends Control

@export var space_between_slot_words : int = 20

const SLOT_WORD = preload("uid://b85g32gol80go")

@onready var slot_word: SlotWord = $Control/HBoxContainer/SlotWord
@onready var h_box_container: HBoxContainer = $Control/HBoxContainer

var newest_slot_word : SlotWord 

#func _ready() -> void:
	#slot_word.question_ui = self
	#newest_slot_word = slot_word

#func create_slot_word() -> void:
	#var new_slot_word : SlotWord = SLOT_WORD.instantiate()
	#h_box_container.add_child(new_slot_word)
	#
	#new_slot_word.question_ui = self
	#
	#new_slot_word.global_position = newest_slot_word.global_position
	#new_slot_word.global_position.x = newest_slot_word.global_position.x + space_between_slot_words
