class_name Alice
extends Node2D

enum actions {LOOK_AT, USE, WALK_TO}
enum thruthfull_states {THRUTHFULLY, HALF_TRUTHFULLY, NOT_TRUTHFULLY}

@onready var wonderbar: Wonderbar = $Wonderbar



var last_question_asked : String = "test"

func _ready() -> void:
	GameManager.alice = self

func alice_receiving_question(question : String, action: actions, item : Item) -> void:
	if question == last_question_asked:
		wonderbar.lower_bar(1)
	else:
		var truthfull_state : thruthfull_states = compair_wonderbar_to_dice_roll()
		
		if truthfull_state:
			match action:
				actions.LOOK_AT:
					talk_about(item.dialogs ,truthfull_state)
				actions.USE:
					move(item.global_position, truthfull_state)
					interact(item,  truthfull_state)
				actions.WALK_TO:
					move(item.global_position, truthfull_state)
		else:
			print("something going wrong")
		
	
	last_question_asked = question

func roll_dice() -> int:
	return randi_range(wonderbar.minimum_roll, wonderbar.maximum_roll)

func compair_wonderbar_to_dice_roll() -> thruthfull_states:
	var differance : int = wonderbar.check_state() - roll_dice()
	var truthfull_state : thruthfull_states
	
	if differance >= wonderbar.minimum_roll / 2 && differance <= wonderbar.maximum_roll / 2:
		truthfull_state = thruthfull_states.HALF_TRUTHFULLY
	elif differance >= 0:
		truthfull_state = thruthfull_states.THRUTHFULLY
	elif differance <= 0:
		truthfull_state = thruthfull_states.NOT_TRUTHFULLY
	else:
		print("error: " , differance)
	
	return truthfull_state


func move(new_pos: Vector2, truthfull_state: thruthfull_states) -> void:
	var tween : Tween = create_tween()
	
	tween.tween_property(self, "global_position", new_pos, 1)

func interact(item : Item, truthfull_state: thruthfull_states) -> void:
	if item.item_to_give[0]:
		var next_item : Item = item.item_to_give[0]
		
		var check_excistance = next_item.check_if_word_excists()
		if check_excistance == false:
			GameManager.word_manager.instance_word(next_item.own_word_name)


func talk_about(dialog_array : Array[DialogActivator], truthfull_state: thruthfull_states) -> void:
	var dialog_activator : DialogActivator  = dialog_array[truthfull_state]
	CutsceneManager.start_dialog(dialog_activator)
	


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("draggable_click") && GameManager.scene_manager.room_state == GameManager.scene_manager.rooms.alice_room:
		GameManager.scene_manager.open_question_screen()
