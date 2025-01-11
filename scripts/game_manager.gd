class_name GameManager
extends Node

@export var background_color: Color

func _ready() -> void:
	RenderingServer.set_default_clear_color(background_color)



func _process(_delta: float) -> void:
	pass
	
