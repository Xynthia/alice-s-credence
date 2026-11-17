class_name Charachter
extends CharacterBody2D

@export var info : CharachterInfo
@export var dialog : DialogActivator

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass
	#if Input.is_action_just_pressed("mouse left click"):
		#if !CutsceneManager.in_dialog:
			#CutsceneManager.start_dialog(dialog)
			#CutsceneManager.dialog_ui.show_charachter_amount(1)
