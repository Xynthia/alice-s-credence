class_name Alice
extends Node2D

var world : World 

@onready var wonderbar: Wonderbar = $Wonderbar


var last_question_asked : String = "test"

func _ready() -> void:
	GameManager.alice = self

func alice_receiving_question(question : String) -> void:
	if question == last_question_asked:
		wonderbar.lower_bar(1)
	else:
		compair_wonderbar_to_dice_roll()
	
	last_question_asked = question

func roll_dice() -> int:
	return randi_range(wonderbar.minimum_roll, wonderbar.maximum_roll)

func compair_wonderbar_to_dice_roll():
	var differance : int = wonderbar.check_state() - roll_dice()
	
	if differance >= wonderbar.minimum_roll / 2 && differance <= wonderbar.maximum_roll / 2:
		respond_half_truthfully()
	elif differance >= 0:
		respond_truthfully()
	elif differance <= 0:
		respond_not_truthfully()
	else:
		print("error: " , differance)


func respond_truthfully() -> void:
	print("is positive")

func respond_half_truthfully() -> void:
	print("is the same")

func respond_not_truthfully() -> void:
	print("is negative")


func move() -> void:
	pass

func interact() -> void:
	pass

func talk_about() -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	GameManager.warren.asking_alice_question()
