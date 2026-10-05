extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


var charachters_in_interaction_range : Array[Charachter]

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse left click") && charachters_in_interaction_range.size() >= 1:
		if !CutsceneManager.in_dialog:
			CutsceneManager.start_dialog(charachters_in_interaction_range[0].dialog)
			CutsceneManager.dialog_ui.show_charachter_amount(1)
		else:
			CutsceneManager.continue_dialog()
	
	move_and_slide()
