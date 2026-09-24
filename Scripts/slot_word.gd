class_name SlotWord
extends Area2D

var is_filled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_child_entered_tree(word: Word) -> void:
	is_filled = true

func _on_child_exiting_tree(word: Word) -> void:
	is_filled = false
