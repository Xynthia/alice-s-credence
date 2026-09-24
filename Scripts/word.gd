class_name Word
extends Area2D

var world : World

@onready var label: Label = $Label
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var rectangle : RectangleShape2D = collision_shape_2d.shape

@export var margin_word : int = 10

var slot_word : SlotWord
var other_word : Word

var dragging : bool = false
var mouse_offset : Vector2
var delay : int = 10

func _ready() -> void:
	world = get_parent()
	set_word("need to test this")

func _process(delta: float) -> void:
	if dragging:
		var tween : Tween = create_tween()
		tween.tween_property(self, "global_position", get_global_mouse_position() - mouse_offset, delay * delta)


func set_word(new_word : String) -> void:
	label.text = new_word


func _on_label_resized() -> void:
	var new_size : Vector2 = label.size + (margin_word * Vector2.ONE)
	rectangle.size = new_size
	nine_patch_rect.size = new_size
	nine_patch_rect.position = -new_size / 2

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("mouse left click"):
		mouse_offset =  get_local_mouse_position()
		dragging = true
	if event.is_action_released("mouse left click"):
		if slot_word:
			reparent(slot_word)
		if other_word:
			move_over()
		dragging = false

func move_over() -> void:
	var next_area_free : Vector2 = check_side()
	var tween : Tween = create_tween()
	tween.tween_property(self, "global_position", next_area_free, delay * get_process_delta_time())
	

func check_side() -> Vector2:
	var finding_spot : bool = true
	var dir : Vector2 = Vector2.UP
	var new_pos = other_word.rectangle.size * dir
	
	while(finding_spot):
		var space_state = get_world_2d().direct_space_state
		var parameters = PhysicsPointQueryParameters2D.new()
		parameters.position = new_pos
		
		var results = space_state.intersect_point(parameters)
		
		if results.size() > 0:
			match dir:
				Vector2.UP:
					dir = Vector2.RIGHT
				Vector2.RIGHT:
					dir = Vector2.DOWN
				Vector2.DOWN:
					dir = Vector2.LEFT
		else:
			finding_spot = false
	
	return new_pos

func _on_word_area_entered(area: Word) -> void:
	other_word = area

func _on_word_area_exited(area: Area2D) -> void:
	other_word = null

func _on_slot_word_area_entered(area: SlotWord) -> void:
	if !area.is_filled:
		slot_word = area


func _on_slot_word_area_exited(area: SlotWord) -> void:
	if area.is_filled:
		slot_word = null
		reparent(world)
