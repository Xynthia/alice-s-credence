class_name SceneManager
extends Node

@export var intro_dialog : DialogActivator

@onready var fade_in_out_screen: ColorRect = $UI/FadeInOutScreen
@onready var screen_area_2d: Area2D = $World2D/ScreenArea2D
@onready var camera_2d: Camera2D = $World2D/Camera2D
@onready var alice_room_timer: Timer = $World2D/AliceRoomTimer

@onready var question: Question = $World2D/Node2D/Question


@onready var popup: Control = $UI/popup
@onready var popup_panel: Panel = $UI/popup/popupPanel
@onready var popup_rich_text_label: RichTextLabel = $UI/popup/popupRichTextLabel

const black : Color = Color(0.0, 0.0, 0.0)
const transparent : Color = Color(0.0, 0.0, 0.0, 0.0)
const white : Color = Color.WHITE

const zoom_camera : Vector2 = Vector2(3.0, 3.0)
const normal_camera : Vector2 = Vector2(1.0, 1.0)
const zoom_pos_camera : Vector2 = Vector2(614.39, 219.225) 
const normal_pos_camera : Vector2 = Vector2(576.0, 320.0)

enum rooms {warrens_room, alice_room}

var room_state : rooms = rooms.warrens_room

var pop_time : float = 1

var in_question : bool = false
var can_interact : bool = false
var clicked_on_pc: bool = false
var fading : bool = false
var zooming : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.scene_manager = self
	#start_intro()
	pass



func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("draggable_click"):
		if CutsceneManager.in_dialog:
			CutsceneManager.continue_dialog()
		else:
			can_interact = true

func start_intro() -> void:
	can_interact = false
	await fade_out()
	if !CutsceneManager.in_dialog:
		CutsceneManager.start_dialog(intro_dialog)

func fade_in() -> void:
	if !fading:
		fading = true
		can_interact = false
		fade_in_out_screen.color = transparent
		fade_in_out_screen.visible = true
		var tween : Tween = create_tween()
		tween.tween_property(fade_in_out_screen, "color", black, 3)
		await tween.finished
		can_interact = true
		fading = false

func fade_out() -> void:
	if !fading:
		fading = true
		can_interact = false
		fade_in_out_screen.color = black
		var tween : Tween = create_tween()
		tween.tween_property(fade_in_out_screen, "color", transparent, 3)
		await tween.finished
		can_interact = true
		fading = false
		fade_in_out_screen.visible = false

func zoom_in() ->void:
	if !zooming:
		zooming = true
		can_interact = false
		var tween : Tween = create_tween()
		tween.tween_property(camera_2d, "position", zoom_pos_camera, 3)
		tween.set_parallel()
		tween.tween_property(camera_2d, "zoom", zoom_camera, 3)
		await tween.finished
		can_interact = true
		zooming = false

func zoom_out() ->void:
	if !zooming:
		zooming = true
		can_interact = false
		var tween : Tween = create_tween()
		tween.tween_property(camera_2d, "zoom", normal_camera, 3)
		tween.set_parallel()
		tween.tween_property(camera_2d, "position", normal_pos_camera, 3)
		await tween.finished
		can_interact = true
		zooming = false


func _on_screen_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if can_interact && event.is_action("draggable_click"):
		clicked_on_pc = true
		if room_state == rooms.warrens_room:
			if !zooming:
				await zoom_in()
				room_state = rooms.alice_room


func _on_alice_room_timer_timeout() -> void:
	clicked_on_pc = false

func open_question_screen() -> void:
	question.visible = true
	in_question = true

func close_question_screen() -> void:
	question.visible = false
	in_question = false

func fade_in_popup() -> void:
	popup.modulate = transparent
	popup.visible = true
	var tween : Tween = create_tween()
	tween.tween_property(popup, "modulate", white, pop_time)
	await tween.finished

func fade_out_popup() -> void:
	popup.modulate = white
	var tween : Tween = create_tween()
	tween.tween_property(popup, "modulate", transparent, pop_time)
	await tween.finished
	popup.visible = false

func update_popup(word : Word) -> void:
	popup_rich_text_label.text = word.word + " has been added!"
	await fade_in_popup()
	await get_tree().create_timer(pop_time).timeout
	await fade_out_popup()

func _on_outside_screen_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if can_interact && !in_question && event.is_action("draggable_click"):
		if room_state == rooms.alice_room:
			await zoom_out()
			room_state = rooms.warrens_room
