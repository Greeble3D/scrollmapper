extends Node

## This global class detects user input and stores the input status in variables.
## Other scripts can use these variables to check if specific actions are occurring.
## This simplifies input detection for common actions in the software.

## signals that a click was just performed.
signal clicked

## signals that a double click was just performed.
signal double_clicked

## Signals that the dragging of the mouse has started.
signal mouse_drag_started(position: Vector2)

## Signals that the mouse drag has ended at a given position.
signal mouse_drag_ended(position: Vector2)

var is_dragging = false
var drag_start_position = Vector2()

func _ready() -> void:
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if event.double_click:
					double_clicked.emit()
				else:
					clicked.emit()
					is_dragging = true
					drag_start_position = event.position
					mouse_drag_started.emit(event.position)
			else:
				if is_dragging:
					is_dragging = false
					mouse_drag_ended.emit(event.position)
	elif event is InputEventMouseMotion:
		if is_dragging:
			# Handle mouse dragging logic here if needed
			pass
