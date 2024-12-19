extends Control
class_name settings_button

var saved_text = "user://debug_list.tres"

var just_hovered = false
var hovered = false

export var unhoverable = false

onready var text = $text
onready var text_pos = $text.rect_position

var index = 0
var key = ""

func _ready() -> void:
	$ColorRect.show_behind_parent = true
	if unhoverable:
		modulate = Color(0.5,0.5,0.5,1)
	else:
		$ColorRect.modulate = Color(0,0,0,5)
		
	if $text.text == "":
		hide()

func save_settings(value = null):
	get_parent().loaded_data[index] = value
	
	get_parent().save()

func _physics_process(delta: float) -> void:
	if not unhoverable:
		text.rect_position = text.rect_position.linear_interpolate(text_pos,delta * 10)
		if hovered:
			text.rect_position.x += 1
			$ColorRect.rect_size.y += (55 - $ColorRect.rect_size.y) * 0.6
			$ColorRect.modulate = $ColorRect.modulate.linear_interpolate(Color(0.8,0.8,0.8,0.1),delta * 10)
			var get_children = get_children()
			get_children.pop_front()
			for i in get_children:
				i.modulate = Color(1,1,1,1)
		else:
			$ColorRect.rect_size.y += (0 - $ColorRect.rect_size.y) * 0.05
			$ColorRect.modulate = $ColorRect.modulate.linear_interpolate(Color(1,1,1,0),delta * 10)
			
#			$ColorRect.modulate = $ColorRect.modulate.linear_interpolate(Color(0.2,0.2,0.2,0.2),delta * 10)
			var get_children = get_children()
			get_children.pop_front()
			for i in get_children:
				i.modulate = Color(0.8,0.8,0.8,2)
					
