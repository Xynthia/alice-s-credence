extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


var charachters_in_interaction_range : Array[Charachter]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("mouse left click") && charachters_in_interaction_range.size() >= 1:
		if !CutsceneManager.in_dialog:
			CutsceneManager.start_dialog(charachters_in_interaction_range[0].dialog)
			CutsceneManager.dialog_ui.show_charachter_amount(1)
		else:
			CutsceneManager.continue_dialog()
	
	move_and_slide()



func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Charachter"):
		charachters_in_interaction_range.append(body)
		print("hi")


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Charachter"):
		charachters_in_interaction_range.erase(body)
		print("bye")
