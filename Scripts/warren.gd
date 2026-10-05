class_name Warren
extends Node2D

var world : World 

func _ready() -> void:
	GameManager.warren = self


func asking_alice_question() -> void:
	var question : String = "test 2"
	GameManager.alice.alice_receiving_question(question)
