class_name Wonderbar
extends Node

@export var minimum_roll : int = -5
@export var maximum_roll : int = 5
@export var starting_roll : int = 0

var current_state : int = starting_roll:
	set(value):
		current_state = clampi(value, minimum_roll, maximum_roll)

func reset() -> void:
	current_state = starting_roll

func lower_bar(amount : int) -> void:
	current_state -= amount

func up_bar(amount : int) -> void:
	current_state += amount

func check_state() -> int:
	return current_state
