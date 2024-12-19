extends Node2D

var pos = Vector2(0,24)
var offset = 0

var settings = false

func _physics_process(delta: float) -> void:
	position = position.linear_interpolate(pos ,delta * 15)
