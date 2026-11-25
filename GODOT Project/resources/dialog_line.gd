class_name DialogLine
extends Resource

@export_multiline() var text : String
@export var next_line : int = -1
@export var choice : Choice
@export var in_convo_with : CharachterInfo
@export var move_charachters : Array[MoveCharachter]
@export var change_expression_charachters : Array[ExpressionCharachters]
@export var play_sfx : AudioStream


func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	pass
