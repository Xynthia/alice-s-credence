class_name SlotWord
extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var rectangle : RectangleShape2D = collision_shape_2d.shape

var question_ui : Question
var is_filled : bool = false
var word : Word


func _on_area_2d_child_entered_tree(new_word: Word) -> void:
	is_filled = true
	#rectangle.size = new_word.rectangle.size
	word = new_word


func _on_area_2d_child_exiting_tree(word: Word) -> void:
	is_filled = false
