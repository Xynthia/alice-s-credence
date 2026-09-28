class_name Charachter
extends CharacterBody2D

@export var info : CharachterInfo
@export var dialog : DialogActivator

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
