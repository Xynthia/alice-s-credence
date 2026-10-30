class_name Alice
extends Node2D

const ALICE = preload("uid://dvfvxl3lv3sip")

enum actions {LOOK_AT, USE, WALK_TO}
enum thruthfull_states {THRUTHFULLY, HALF_TRUTHFULLY, NOT_TRUTHFULLY}

@onready var wonderbar: Wonderbar = $Wonderbar
@onready var emotes: Node2D = $emotes
@onready var angry: Sprite2D = $emotes/angry
@onready var confused: Sprite2D = $emotes/confused
@onready var star: Sprite2D = $emotes/star

var last_question_asked : String = "test"

func _ready() -> void:
	GameManager.alice = self

func alice_receiving_question(question : String, action: actions, item : Item) -> void:
	if question == last_question_asked:
		wonderbar.lower_bar(1)
		var new_dialog_line : DialogLine = DialogLine.new()
		new_dialog_line.text = "You already asked that... I don't want to."
		new_dialog_line.in_convo_with = ALICE
		CutsceneManager.current_cutscene.dialog_lines.append(new_dialog_line)
		show_emote(true, false, false)
	else:
		var truthfull_state : thruthfull_states = compair_wonderbar_to_dice_roll()
		
		if truthfull_state != null:
			match action:
				actions.LOOK_AT:
					talk_about(item.dialogs ,truthfull_state)
					if truthfull_state != thruthfull_states.NOT_TRUTHFULLY:
						item.has_been_looked_at = true
					elif truthfull_state == thruthfull_states.NOT_TRUTHFULLY && item == GameManager.item_manager.bed || truthfull_state == thruthfull_states.NOT_TRUTHFULLY && item == GameManager.item_manager.plant:
						item.has_been_looked_at = false
				actions.USE:
					interact(item,  truthfull_state)
				actions.WALK_TO:
					if item == GameManager.item_manager.bed || item == GameManager.item_manager.cabinet || item == GameManager.item_manager.plant || item == GameManager.item_manager.door:
						move(item.global_position, truthfull_state)
					else:
						var new_dialog_line : DialogLine = DialogLine.new()
						new_dialog_line.text = "I don't think I can reach that."
						new_dialog_line.in_convo_with = ALICE
						CutsceneManager.current_cutscene.dialog_lines.append(new_dialog_line)
		else:
			print("something going wrong")
	last_question_asked = question

func show_emote(angry_state: bool, confused_state: bool, star_state: bool) -> void:
	if angry_state:
		angry.visible = true
	elif confused_state:
		confused.visible = true
	elif star_state:
		star.visible = true
	
	emotes.visible = true
	await get_tree().create_timer(3).timeout
	emotes.visible = false
	angry.visible = false
	confused.visible = false
	star.visible = false

func roll_dice() -> int:
	return randi_range(wonderbar.minimum_roll, wonderbar.maximum_roll)

func compair_wonderbar_to_dice_roll() -> thruthfull_states:
	var differance : int = wonderbar.check_state() - roll_dice()
	var truthfull_state : thruthfull_states
	
	if differance >= wonderbar.minimum_roll / 2 && differance <= wonderbar.maximum_roll / 2:
		truthfull_state = thruthfull_states.HALF_TRUTHFULLY
	elif differance >= 0:
		truthfull_state = thruthfull_states.THRUTHFULLY
	elif differance < 0:
		truthfull_state = thruthfull_states.NOT_TRUTHFULLY
	else:
		print("error: " , differance)
	
	print(truthfull_state)
	return truthfull_state

func move(new_pos: Vector2, truthfull_state: thruthfull_states) -> void:
	var tween : Tween = create_tween()
	
	tween.tween_property(self, "global_position", new_pos, 1)
	await tween.finished

func interact(item : Item, truthfull_state: thruthfull_states) -> void:
	if item == GameManager.item_manager.door:
		if item == GameManager.item_manager.door && !item.has_been_looked_at:
			talk_about(item.dialogs, truthfull_state)
		GameManager.scene_manager.open_door_screen()
		return
	
	if item == GameManager.item_manager.plant && !item.has_been_looked_at || item == GameManager.item_manager.bed && !item.has_been_looked_at:
		var new_dialog_line : DialogLine = DialogLine.new()
		new_dialog_line.text = "I don't understand how you want me to use this... maybe we should look at it first?"
		new_dialog_line.in_convo_with = ALICE
		CutsceneManager.current_cutscene.dialog_lines.append(new_dialog_line)
		return
	
	if item == GameManager.item_manager.clothes || item == GameManager.item_manager.police_badge || item == GameManager.item_manager.picture || item == GameManager.item_manager.calender || item == GameManager.item_manager.pipe || item == GameManager.item_manager.lamp || item == GameManager.item_manager.broken_lamp || item == GameManager.item_manager.shoes:
		var new_dialog_line : DialogLine = DialogLine.new()
		new_dialog_line.text = "I can't really use this, if I look at it, I might find more info."
		new_dialog_line.in_convo_with = ALICE
		CutsceneManager.current_cutscene.dialog_lines.append(new_dialog_line)
		return
	
	if item == GameManager.item_manager.plant && item.item_to_give.size() > 0 && truthfull_state == thruthfull_states.NOT_TRUTHFULLY && item.has_been_looked_at || item == GameManager.item_manager.bed && item.item_to_give.size() > 0 && truthfull_state == thruthfull_states.NOT_TRUTHFULLY && item.has_been_looked_at:
		var new_dialog_line : DialogLine = DialogLine.new()
		new_dialog_line.text = "I don't want to."
		new_dialog_line.in_convo_with = ALICE
		CutsceneManager.current_cutscene.dialog_lines.append(new_dialog_line)
		show_emote(true, false, false)
		return

	if item == GameManager.item_manager.cabinet && !item.has_been_looked_at || item == GameManager.item_manager.case_file && !item.has_been_looked_at  || item == GameManager.item_manager.box && !item.has_been_looked_at :
		talk_about(item.dialogs, truthfull_state)
	
	if item.item_to_give.size() > 0:
		if item == GameManager.item_manager.bed || item == GameManager.item_manager.cabinet || item == GameManager.item_manager.plant || item == GameManager.item_manager.door:
			await move(item.global_position, truthfull_state)
		
		var next_item : Item = item.item_to_give[0]
		var check_excistance = next_item.check_if_word_excists()
		if check_excistance == false && !next_item.has_been_given:
			GameManager.word_manager.instance_word(next_item.own_word_name)
		else:
			var new_dialog_line : DialogLine = DialogLine.new()
			new_dialog_line.text = "I have already gotten what I can get."
			new_dialog_line.in_convo_with = ALICE
			CutsceneManager.current_cutscene.dialog_lines.append(new_dialog_line)

func talk_about(dialog_array : Array[DialogActivator], truthfull_state: thruthfull_states) -> void:
	if dialog_array[truthfull_state]:
		CutsceneManager.current_cutscene.dialog_lines.append(dialog_array[truthfull_state].dialog_lines[0])
	match truthfull_state:
		thruthfull_states.THRUTHFULLY:
			show_emote(false, false, true)
		thruthfull_states.NOT_TRUTHFULLY:
			show_emote(false, true, false)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("draggable_click") && GameManager.scene_manager.room_state == GameManager.scene_manager.rooms.alice_room && !GameManager.scene_manager.in_question:
		GameManager.scene_manager.open_question_screen()
