class_name Word
extends Control

@onready var label: Label = $Label
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

@export var margin_word : int = 10

func _ready() -> void:
	set_word("need to test this")

func set_word(new_word : String) -> void:
	label.text = new_word
	


func _on_label_resized() -> void:
	var new_size : Vector2 = label.size + (margin_word * Vector2.ONE)
	size = new_size
