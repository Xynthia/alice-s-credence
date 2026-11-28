class_name Alice
extends Node2D

enum actions {LOOK_AT, USE, WALK_TO}
enum thruthfull_states {THRUTHFULLY, HALF_TRUTHFULLY, NOT_TRUTHFULLY}

# same order as thruthfull_states
const STATE_CUE_ENDINGS : Array[String] = ["_truthful", "_half", "_not"]

@onready var wonderbar: Wonderbar = $Wonderbar
@onready var emotes: Node2D = $emotes
@onready var angry: Sprite2D = $emotes/angry
@onready var confused: Sprite2D = $emotes/confused
@onready var star: Sprite2D = $emotes/star

var last_question_asked : String = "test"
# cue names, the question cue in alice_room.dialogue plays them in order
var reply_cues : Array[String]

func _ready() -> void:
	GameManager.alice = self
	DialogueManager.got_dialogue.connect(_on_got_dialogue)

func alice_receiving_question(question : String, action: actions, item : Item) -> void:
	reply_cues.clear()
	if question == last_question_asked:
		wonderbar.lower_bar(1)
		reply_cues.append("already_asked")
	else:
		var truthfull_state : thruthfull_states = compair_wonderbar_to_dice_roll()
		
		if truthfull_state != null:
			match action:
				actions.LOOK_AT:
					talk_about(item, truthfull_state)
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
						reply_cues.append("cant_reach")
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

func _on_got_dialogue(line: DialogueLine) -> void:
	if line.has_tag("angry") || line.has_tag("confused") || line.has_tag("star"):
		show_emote(line.has_tag("angry"), line.has_tag("confused"), line.has_tag("star"))

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
			talk_about(item, truthfull_state)
		GameManager.scene_manager.open_door_screen()
		return
	
	if item == GameManager.item_manager.plant && !item.has_been_looked_at || item == GameManager.item_manager.bed && !item.has_been_looked_at:
		reply_cues.append("look_first")
		return
	
	if item == GameManager.item_manager.clothes || item == GameManager.item_manager.police_badge || item == GameManager.item_manager.picture || item == GameManager.item_manager.calender || item == GameManager.item_manager.pipe || item == GameManager.item_manager.lamp || item == GameManager.item_manager.broken_lamp || item == GameManager.item_manager.shoes:
		reply_cues.append("cant_use")
		return
	
	if item == GameManager.item_manager.plant && item.item_to_give.size() > 0 && truthfull_state == thruthfull_states.NOT_TRUTHFULLY && item.has_been_looked_at || item == GameManager.item_manager.bed && item.item_to_give.size() > 0 && truthfull_state == thruthfull_states.NOT_TRUTHFULLY && item.has_been_looked_at:
		reply_cues.append("dont_want_to")
		return

	if item == GameManager.item_manager.cabinet && !item.has_been_looked_at || item == GameManager.item_manager.case_file && !item.has_been_looked_at  || item == GameManager.item_manager.box && !item.has_been_looked_at :
		talk_about(item, truthfull_state)
	
	if item.item_to_give.size() > 0:
		if item == GameManager.item_manager.bed || item == GameManager.item_manager.cabinet || item == GameManager.item_manager.plant || item == GameManager.item_manager.door:
			move(item.global_position, truthfull_state)
		
		var next_item : Item = item.item_to_give[0]
		var check_excistance = next_item.check_if_word_excists()
		if check_excistance == false && !next_item.has_been_given:
			GameManager.word_manager.instance_word(next_item.own_word_name)
		else:
			reply_cues.append("already_got")

func talk_about(item : Item, truthfull_state: thruthfull_states) -> void:
	reply_cues.append(item.dialogue_cue + STATE_CUE_ENDINGS[truthfull_state])

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("draggable_click") && GameManager.scene_manager.room_state == GameManager.scene_manager.rooms.alice_room && !GameManager.scene_manager.in_question:
		GameManager.scene_manager.open_question_screen()
