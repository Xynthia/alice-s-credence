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
var started_end_game : bool = false

func _ready() -> void:
	start_game()

func start_game() -> void:
	started_game = true

func _process(delta: float) -> void:
	if started_game:
		game_timer += delta
		if !started_end_game && game_timer >= game_time:
			end_game(false)

func end_game(good_ending : bool) -> void:
	if good_ending:
		print("good ending")
	else:
		print("times up")
		
	started_end_game = true
	
