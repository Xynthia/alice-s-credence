class_name DialogUI
extends Control

@onready var portraits: Portraits = $Portraits
@onready var portrait: Portrait = $Portraits/Portrait
@onready var portrait_2: Portrait = $Portraits/Portrait2
@onready var portrait_3: Portrait = $Portraits/Portrait3

@onready var dialog_text_label: RichTextLabel = $box/DialogText/DialogTextLabel
@onready var name_box_left_label: RichTextLabel = $box/NameBoxLeft/NameBoxLeftLabel
@onready var name_box_right_label: RichTextLabel = $box/NameBoxRight/NameBoxRightLabel

@onready var name_box_left: Control = $box/NameBoxLeft
@onready var name_box_right: Control = $box/NameBoxRight

var showing_full_line_text : bool = true

var tween : Tween = create_tween()

var on_dialog_text_label_meta_hover : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	CutsceneManager.dialog_ui = self


func show_charachter_amount(amount : int) -> void:
	match amount:
		1:
			portrait.visible = true
			portrait_2.visible = false
			portrait_3.visible = false
		2:
			portrait.visible = true
			portrait_2.visible = true
			portrait_3.visible = false
		3:
			portrait.visible = true
			portrait_2.visible = true
			portrait_3.visible = true

func change_focus_to_char(charachter_info: CharachterInfo) -> void:
	for portrait : Portrait in portraits.get_children():
		if portrait.charachter_info == charachter_info:
			portrait.focus()
		else:
			portrait.unfocus()

func change_dialog_text(new_text : String)-> void:
	dialog_text_label.text = new_text
	dialog_text_label.visible_ratio = 0
	showing_full_line_text = false
	if !tween.is_valid():
		tween = create_tween()
	
	var characters_per_second: float = 30.0
	var duration: float = new_text.length() / characters_per_second
	
	tween.tween_property(dialog_text_label, "visible_ratio", 1 , duration)
	await tween.finished
	showing_full_line_text = true

func change_name_box_left(new_text : String) -> void:
	name_box_left_label.text = new_text

func change_name_box_right(new_text : String) -> void:
	name_box_right_label.text = new_text

func see_full_dialog_text()-> void:
	tween.kill()
	dialog_text_label.visible_ratio = 1
	showing_full_line_text = true



func _on_dialog_text_label_meta_clicked(meta: Variant) -> void:
	GameManager.word_manager.instance_word(meta)


func _on_dialog_text_label_meta_hover_ended(meta: Variant) -> void:
	on_dialog_text_label_meta_hover = false


func _on_dialog_text_label_meta_hover_started(meta: Variant) -> void:
	on_dialog_text_label_meta_hover = true


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("mouse left click") && !on_dialog_text_label_meta_hover:
		CutsceneManager.continue_dialog()
