class_name SceneManager
extends Node

@export var intro_dialog : DialogActivator
@export var alice_on_screen_dialog : DialogActivator
@export var alice_zoomed_in : DialogActivator

@onready var fade_in_out_screen: ColorRect = $UI/FadeInOutScreen
@onready var screen_area_2d: Area2D = $World2D/scherm/ScreenArea2D
@onready var camera_2d: Camera2D = $World2D/Camera2D
@onready var alice_room_timer: Timer = $World2D/AliceRoomTimer
@onready var question: Question = $World2D/scherm/Question

@onready var main_menu: Node2D = $"World2D/main menu"

@onready var scherm: Node2D = $World2D/scherm
@onready var animation_player: AnimationPlayer = $World2D/scherm/AnimationPlayer
@onready var alice_s_room: Node2D = $"World2D/scherm/Alice's Room"

@onready var popup: Control = $UI/popup
@onready var popup_panel: Panel = $UI/popup/popupPanel
@onready var popup_rich_text_label: RichTextLabel = $UI/popup/popupRichTextLabel
@onready var popup_timer: Timer = $World2D/PopupTimer
@onready var hours_label: RichTextLabel = $UI/hoursLabel

const black : Color = Color(0.0, 0.0, 0.0)
const transparent : Color = Color(0.0, 0.0, 0.0, 0.0)
const white : Color = Color.WHITE

const zoom_camera : Vector2 = Vector2(3.0, 3.0)
const zoom_intro_camera : Vector2 = Vector2(2.0, 2.0)
const normal_camera : Vector2 = Vector2(1.0, 1.0)
const zoom_pos_camera : Vector2 = Vector2(614.39, 235) 
const zoom_intro_pos_camera : Vector2 = Vector2(576.0, 520.98) 
const normal_pos_camera : Vector2 = Vector2(576.0, 320.0)

enum rooms {warrens_room, alice_room}

var room_state : rooms = rooms.warrens_room

var fade_time : float = 2
var zoom_time : float = 1.5
var pop_time : float = 1

var timer_for_popup : float = 0

var zoom_in_on_alice_first_time : bool = false
var in_question : bool = false
var can_interact : bool = false
var clicked_on_pc: bool = false
var fading : bool = false
var zooming : bool = false

var question_ui : bool = false
var door_ui : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.scene_manager = self
	turn_on_main_menu()
	start_intro()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("draggable_click"):
		if CutsceneManager.in_dialog:
			CutsceneManager.continue_dialog()
		else:
			can_interact = true

func start_intro() -> void:
	can_interact = false
	if !CutsceneManager.in_dialog:
		CutsceneManager.start_dialog(intro_dialog)

func start_alice_on_screen_dialog() -> void:
	await open_screen()
	can_interact = false
	if !CutsceneManager.in_dialog:
		CutsceneManager.start_dialog(alice_on_screen_dialog)

func start_intr_part_2() -> void:
	can_interact = false
	if !CutsceneManager.in_dialog:
		CutsceneManager.start_dialog(alice_zoomed_in)

func fade_in() -> void:
	if !fading:
		fading = true
		can_interact = false
		fade_in_out_screen.color = transparent
		fade_in_out_screen.visible = true
		var tween : Tween = create_tween()
		tween.tween_property(fade_in_out_screen, "color", black, fade_time)
		await tween.finished
		can_interact = true
		fading = false

func fade_out() -> void:
	if !fading:
		fading = true
		can_interact = false
		fade_in_out_screen.color = black
		fade_in_out_screen.visible = true
		var tween : Tween = create_tween()
		tween.tween_property(fade_in_out_screen, "color", transparent, fade_time)
		await tween.finished
		can_interact = true
		fading = false
		fade_in_out_screen.visible = false

func zoom_in() ->void:
	if !zooming:
		if !zoom_in_on_alice_first_time:
			start_intr_part_2()
			zoom_in_on_alice_first_time = true
		zooming = true
		can_interact = false
		var tween : Tween = create_tween()
		tween.tween_property(camera_2d, "position", zoom_pos_camera, zoom_time)
		tween.set_parallel()
		tween.tween_property(camera_2d, "zoom", zoom_camera, zoom_time)
		await tween.finished
		can_interact = true
		zooming = false

func zoom_out() ->void:
	if !zooming:
		zooming = true
		can_interact = false
		var tween : Tween = create_tween()
		tween.tween_property(camera_2d, "zoom", normal_camera, zoom_time)
		tween.set_parallel()
		tween.tween_property(camera_2d, "position", normal_pos_camera, zoom_time)
		await tween.finished
		can_interact = true
		zooming = false


func _on_screen_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if can_interact && !fading && event.is_action("draggable_click"):
		clicked_on_pc = true
		if room_state == rooms.warrens_room:
			if !zooming:
				await zoom_in()
				room_state = rooms.alice_room


func _on_alice_room_timer_timeout() -> void:
	clicked_on_pc = false

func open_question_screen() -> void:
	question.visible = true
	question.door_ui.visible = false
	question.question_ui.visible = true
	in_question = true
	question_ui = true
	door_ui = false

func open_door_screen() -> void:
	question.visible = true
	question.door_ui.visible = true
	question.question_ui.visible = false
	in_question = true
	question_ui = false
	door_ui = true

func close_question_screen() -> void:
	question.visible = false
	question.door_ui.visible = false
	question.question_ui.visible = false
	in_question = false
	question_ui = true
	door_ui = false
	

func fade_in_popup() -> void:
	popup.modulate = transparent
	popup.visible = true
	var tween : Tween = create_tween()
	tween.tween_property(popup, "modulate", white, pop_time)
	await tween.finished
	popup_timer.start()

func fade_out_popup() -> void:
	popup.modulate = white
	var tween : Tween = create_tween()
	tween.tween_property(popup, "modulate", transparent, pop_time)
	await tween.finished
	popup.visible = false

func update_popup(word : Word) -> void:
	popup_rich_text_label.text = word.word + " has been added!"
	await fade_in_popup()
	
	popup_timer.wait_time = pop_time

func open_screen() -> void:
	animation_player.play("open screen")
	await animation_player.animation_finished
	alice_s_room.visible = true

func close_screen() -> void:
	animation_player.play("close screen")
	await animation_player.animation_finished
	alice_s_room.visible = false

func turn_off_main_menu() -> void:
	fade_in()
	await get_tree().create_timer(fade_time).timeout
	main_menu.visible = false
	camera_2d.zoom = normal_camera
	camera_2d.global_position = normal_pos_camera
	await fade_out()

func turn_on_main_menu() -> void:
	main_menu.visible = true
	camera_2d.zoom = zoom_intro_camera
	camera_2d.global_position = zoom_intro_pos_camera



func _on_outside_screen_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if can_interact && !in_question && event.is_action("draggable_click"):
		if room_state == rooms.alice_room:
			await zoom_out()
			room_state = rooms.warrens_room

func _on_start_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("draggable_click"):
		GameManager.start_game()

func _on_quit_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("draggable_click"):
		get_tree().quit()


func _on_popup_timer_timeout() -> void:
	fade_out_popup()
