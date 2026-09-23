class_name Warren
extends Node2D

var world : World 

func _ready() -> void:
	world = get_parent()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		asking_alice_question()

func asking_alice_question() -> void:
	var question : String = "test 2"
	world.alice.alice_receiving_question(question)
	
	
