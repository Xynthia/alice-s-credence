class_name Item
extends Node2D

var item_manager : ItemManager

@export var own_word_name : String 

@export var truthfull_dialog : DialogActivator
@export var half_truthfull_dialog : DialogActivator
@export var not_truthfull_dialog : DialogActivator

@export var item_to_give : Array[Item]

var has_been_looked_at : bool = false
var has_been_given : bool = false

var dialogs : Array[DialogActivator] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_manager = get_parent()
	
	dialogs.append(truthfull_dialog)
	dialogs.append(half_truthfull_dialog)
	dialogs.append(not_truthfull_dialog)
	
	item_manager.items.append(self)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("draggable_click") && GameManager.scene_manager.room_state == GameManager.scene_manager.rooms.alice_room:
		var check_excistance = check_if_word_excists()
		if check_excistance == false:
			GameManager.word_manager.instance_word(own_word_name)
			has_been_given = true

func check_if_word_excists() -> bool:
	for word in GameManager.word_manager.words:
		if word.word == own_word_name:
			return true
	
	return false
