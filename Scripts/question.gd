class_name Question
extends Node2D

@export var space_between_slot_words : int = 20

const SLOT_WORD = preload("uid://b85g32gol80go")

@onready var slot_word: SlotWord = $SlotWord
@onready var option_button: OptionButton = $"Control/question ui/OptionButton"

var newest_slot_word : SlotWord 

func _ready() -> void:
	slot_word.question_ui = self
	newest_slot_word = slot_word

func create_slot_word() -> void:
	var new_slot_word : SlotWord = SLOT_WORD.instantiate()
	add_child(new_slot_word)
	
	new_slot_word.question_ui = self
	
	new_slot_word.global_position = newest_slot_word.global_position
	new_slot_word.global_position.x = newest_slot_word.global_position.x + space_between_slot_words


func _on_button_pressed() -> void:
	if slot_word.word:
		var question_string : String = "Alice can you " + str(option_button.get_item_text(option_button.selected)) + " " + str(slot_word.word.word) +"?"
		var item : Item = GameManager.item_manager.find_word(slot_word.word)
		
		var next_dialog : DialogActivator = DialogActivator.new()
		var next_line : DialogLine = DialogLine.new()
		next_line.text = question_string
		
		next_dialog.dialog_lines.append(next_line)
		
		if item:
			CutsceneManager.start_dialog(next_dialog)
			await get_tree().create_timer(1).timeout
			
			GameManager.alice.alice_receiving_question(question_string, option_button.selected, item)
		else:
			print("no item found")


func _on_return_button_pressed() -> void:
	GameManager.scene_manager.close_question_screen()
