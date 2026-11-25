class_name Portrait
extends Control

@export var charachter_info : CharachterInfo

@onready var sprite_2d: Sprite2D = $Sprite2D

var focus_color : Color = Color(1.0, 1.0, 1.0)
var unfocus_color : Color = Color(0.427, 0.427, 0.427)

func focus() -> void:
	sprite_2d.modulate = focus_color

func unfocus() -> void:
	sprite_2d.modulate = unfocus_color
