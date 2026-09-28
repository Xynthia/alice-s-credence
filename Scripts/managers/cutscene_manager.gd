extends Node

@onready var dialog_ui: DialogUI 

var current_cutscene : DialogActivator
var current_line_id : int = 0

var in_dialog : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func start_dialog(next_dialog : DialogActivator) -> void:
	if next_dialog:
		in_dialog = true
		current_cutscene = next_dialog
		dialog_ui.visible = true
		go_to_next_line(0)

func continue_dialog() -> void:
	if !dialog_ui.on_dialog_text_label_meta_hover:
		go_to_next_line(current_cutscene.dialog_lines[current_line_id].next_line)

func end_dialog() -> void:
	in_dialog = false
	dialog_ui.visible = false

func go_to_next_line(next_line_id : int) -> void:
	if next_line_id == -1:
		next_line_id = current_line_id + 1
	
	if !dialog_ui.showing_full_line_text:
		#skipping line to full visibility
		dialog_ui.see_full_dialog_text()
		return
	
	if next_line_id > current_cutscene.dialog_lines.size() -1 && dialog_ui.showing_full_line_text:
		#done with dialog
		end_dialog()
		return
	
	dialog_ui.change_focus_to_char(current_cutscene.dialog_lines[next_line_id].in_convo_with)
	
	dialog_ui.change_dialog_text(current_cutscene.dialog_lines[next_line_id].text)
	current_line_id = next_line_id
