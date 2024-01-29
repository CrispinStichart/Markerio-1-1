extends Node2D

# This is all terrible. I have no idea what the interaction is between
# canvasas and viewports. This is almost certainly a terrible way
# to do what I wanted.
@onready var size := Vector2(get_viewport_rect().size)
@onready var canvas_transform := Transform2D(get_viewport().canvas_transform)
