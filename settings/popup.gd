extends Control

var context =  0

onready var rect_r = $Control/rect.margin_right
onready var rect_l = $Control/rect.margin_left
onready var rect_t = $Control/rect.margin_top 
onready var rect_b = $Control/rect.margin_bottom

onready var rect = $Control/rect

func _ready() -> void:
	rect.margin_bottom = 0
	rect.margin_right = 0
	rect.margin_top = 0
	rect.margin_left = 0

func _physics_process(delta: float) -> void:
	rect.margin_right += (rect_r - rect.margin_right) * 0.2
	rect.margin_left += (rect_l - rect.margin_left) * 0.2
	rect.margin_top += (rect_t - rect.margin_top) * 0.2
	rect.margin_bottom += (rect_b - rect.margin_bottom) * 0.2

	$Control/rect/ColorRect.modulate = $Control/rect/ColorRect.modulate.linear_interpolate(Color.black,delta * 18)
	
	if context == 0:
		var text_to_save = get_parent().get_node("TextEdit").text 
	
func quit():
	get_parent().get_parent().popup = false
		
		
	
