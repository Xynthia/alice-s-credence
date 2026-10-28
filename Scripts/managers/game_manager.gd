extends Node

var warren : Warren
var alice : Alice

var scene_manager : SceneManager
var word_manager : WordManager

var item_manager : ItemManager
const ITEM_MANAGER = preload("uid://dsxdcmd01630g")

var game_time : float = 4 * 60
var game_timer : float = 0

var started_game : bool = false
var finished_intro : bool = false
var started_end_game : bool = false

func start_game() -> void:
	started_game = true
	await scene_manager.turn_off_main_menu()
	scene_manager.start_alice_on_screen_dialog()

func _process(delta: float) -> void:
	if started_game && finished_intro && game_timer <= game_time:
		game_timer += delta
		
		match int(game_timer):
			180:
				show_time(1)
				game_timer = 181
			120:
				show_time(2)
				game_timer = 121
			60:
				show_time(3)
				game_timer = 61
		
	if started_game && finished_intro && !started_end_game && game_timer >= game_time:
		end_game(false)

func show_time(hours_left : int) -> void:
	get_tree().paused = true
	await scene_manager.fade_in()
	
	if hours_left == 1:
		scene_manager.hours_label.text = str(hours_left) + " hour left"
	else:
		scene_manager.hours_label.text = str(hours_left) + " hours left"
	scene_manager.hours_label.visible = true
	await get_tree().create_timer(3).timeout
	scene_manager.hours_label.visible = false
	await scene_manager.fade_out()
	get_tree().paused = false

func end_game(good_ending : bool) -> void:
	var text : String
	if good_ending:
		text = "The kidnapper let the authorities know the location of Alice. They were able to save her.\n ...and you were not found guilty of kindnapping Alice"
	else:
		text = "You got arrested. \nYou have too much evidence against you. \nYou were sentenced guilty to the kidnapping of alice."
		
	started_end_game = true
	get_tree().paused = true
	await scene_manager.fade_in()
	scene_manager.hours_label.text = text
	scene_manager.hours_label.visible = true
	
	await get_tree().create_timer(12).timeout
	
	scene_manager.hours_label.visible = false
	
	scene_manager.question._on_return_button_pressed()
	item_manager.reset()
	word_manager.reset()
	game_timer = 0
	get_tree().paused = false
	scene_manager.room_state = scene_manager.rooms.warrens_room
	scene_manager.zoom_in_on_alice_first_time = false
	scene_manager.turn_on_main_menu()
	await scene_manager.fade_out()
	
	started_game = false
	started_end_game = false
	finished_intro = false
	
	
