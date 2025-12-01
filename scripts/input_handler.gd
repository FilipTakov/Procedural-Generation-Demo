extends Node

@onready var camera_2d: Camera2D = $"../Camera2D"

func _unhandled_input(event):
		
	# Simple Camera Pan
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_2d.zoom += Vector2(0.1, 0.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_2d.zoom -= Vector2(0.1, 0.1)
