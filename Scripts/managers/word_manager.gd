class_name WordManager
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var rectangle : RectangleShape2D = collision_shape_2d.shape

var words : Array[Word]
const WORD = preload("uid://cqk1rjw7rm52g")

func _ready() -> void:
	GameManager.word_manager = self

func instance_word(value : Variant)-> void:
	var new_word : Word = WORD.instantiate()
	words.append(new_word)
	new_word.word = value
	words.find(value)
	new_word.name = new_word.word
	new_word.global_position = get_random_pos()
	
	add_child(new_word)

func get_random_pos() -> Vector2:
	var padding : float = 10
	var random_x : float = randf_range(global_position.x + padding, rectangle.size.x + global_position.x - padding)
	var random_y : float = randf_range(global_position.y - padding, rectangle.size.y + global_position.y + padding)
	
	return Vector2(random_x, random_y)
