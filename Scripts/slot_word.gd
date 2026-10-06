class_name SlotWord
extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var rectangle : RectangleShape2D = collision_shape_2d.shape

var question_ui : Question
var is_filled : bool = false


func _on_child_entered_tree(word: Word) -> void:
	is_filled = true
	rectangle.size = word.rectangle.size
	question_ui.create_slot_word()

func _on_child_exiting_tree(word: Word) -> void:
	is_filled = false
