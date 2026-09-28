class_name Word
extends Area2D

var world : World
var word_manager : WordManager

@onready var label: Label = $Label
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var rectangle : RectangleShape2D = collision_shape_2d.shape

@export var word : String:
	set(value):
		word = value
		if label:
			set_label(value)

@export var margin_word : int = 10

var slot_word : SlotWord
var other_word : Word

var moving : bool = false
var dragging : bool = false
var mouse_offset : Vector2
var delay : int = 10
var moving_tween : Tween = Tween.new()


func _ready() -> void:
	#world = get_parent().get_parent()
	word_manager = get_parent()
	set_label(word)

func _process(delta: float) -> void:
	pass
	if dragging:
		moving_tween = create_tween()
		moving_tween.tween_property(self, "global_position", get_global_mouse_position() - mouse_offset, delay * delta)
	else:
		moving_tween.kill()


func visible(value : bool) -> void:
	label.visible = value
	nine_patch_rect.visible = value

func set_label(new_word : String) -> void:
	label.text = new_word

func _on_label_resized() -> void:
	if label:
		var new_size : Vector2 = label.size + (margin_word * Vector2.ONE)
		rectangle.size = new_size
		nine_patch_rect.size = new_size
		nine_patch_rect.position = -new_size / 2

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("mouse left click"):
		mouse_offset =  get_local_mouse_position()
		dragging = true
	else:
		if slot_word && !slot_word.is_filled:
			reparent(slot_word)
		if other_word && get_parent().get_script().get_global_name() != "SlotWord":
			move_over()
		dragging = false

func move_over() -> void:
	var next_area_free : Vector2 = check_side()
	var tween : Tween = create_tween()
	moving = true
	tween.tween_property(self, "global_position", next_area_free, delay * get_process_delta_time())
	await tween.finished
	moving = false

func check_side() -> Vector2:
	var finding_spot : bool = true
	var dir : Vector2 = Vector2.RIGHT
	var new_pos = global_position + (rectangle.size * 1.5) * dir
	
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
	if !dragging && !moving:
		other_word.move_over()

func _on_word_area_exited(area: Area2D) -> void:
	other_word = null

func _on_slot_word_area_entered(area: SlotWord) -> void:
	if !area.is_filled:
		slot_word = area

func _on_slot_word_area_exited(area: SlotWord) -> void:
	if area.is_filled:
		slot_word = null
		reparent(world)
