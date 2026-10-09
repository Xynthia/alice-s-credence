class_name Word
extends Area2D

var world : World
var word_manager : WordManager

@onready var label: Label = $Label
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var rectangle : RectangleShape2D = collision_shape_2d.shape
@onready var draggable: Draggable = $Draggable

@export var word : String:
	set(value):
		word = value
		if label:
			set_label(value)

@export var margin_word : int = 10

var slot_word : SlotWord
var other_word : Word

func _ready() -> void:
	set_label(word)

func visible(value : bool) -> void:
	label.visible = value
	nine_patch_rect.visible = value

func set_label(new_word : String) -> void:
	label.text = new_word

func _on_label_resized() -> void:
	if label:
		var new_size : Vector2 = label.size + (margin_word * Vector2.ONE)
		rectangle.size = new_size
		nine_patch_rect.size = new_size
		nine_patch_rect.position = -new_size / 2
