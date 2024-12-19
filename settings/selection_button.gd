extends settings_button

var selection_button = []
var selected_button = null

var last_selected_button = null
var activated = false

var biggest_size = 0
var hovered_index = 0

var selections_text = []

func _ready() -> void:
	selections_text = ResourceLoader.load(saved_text).settings_value[index][0]
#	print(selections_text)
	
	
	for i in range(selections_text.size() ):
		var text_inst = $selection_container/text.duplicate()
		text_inst.text = str(selections_text[i])
		$selection_container.add_child(text_inst)
		selection_button.append(text_inst)
		text_inst.rect_position = $selection_container/Position2D.position + Vector2(0, i * 10)
		text_inst.hide()
	
		if selections_text[i].length() > biggest_size:
			biggest_size = 8 + selections_text[i].length() * 5
	
	print(ResourceLoader.load(saved_text).settings_value[index])

#	$selection_container/text.text = selections_text[ResourceLoader.load(saved_text)[index][1]]
	
func _physics_process(delta: float) -> void:
	$selection_container/ColorRect.modulate = $selection_container/ColorRect.modulate.linear_interpolate(Color.black,delta * 5)
	
	if hovered:
		if just_hovered == true:
			$selection_container/ColorRect.modulate = Color.white
			just_hovered = false
		$selection_container/Control/dropdown_icon.show()
		if Input.is_action_just_pressed("CLICK"):
			
			if get_parent().dropdown == false:
				$selection_container/ColorRect.modulate = Color(0.5,0.5,0.5)
				
				for i in range(selection_button.size()):
					selection_button[i].rect_position.x -= 15 + 15 * (i)
				if selected_button != null:
					$selection_container/text.text = str(selected_button.text)
			else:
				
				$selection_container/ColorRect.modulate = Color(1.5,1.5,1.5,3)
				
				if selected_button != null:
					$selection_container/text.text = str(selected_button.text)
					save_settings([selections_text,hovered_index])

				
			get_parent().dropdown = !get_parent().dropdown
			get_parent().button_in_dropdown = index
			get_parent().dropdown_push_strength = 8 + selection_button.size() * 10
			
		if get_parent().dropdown:
			$selection_container/Control/dropdown_icon.hide()
			
#			$selection_container/text.hide()
			show_on_top = true
			rect_size.y = 30 + (selection_button.size() * 10)
			if get_local_mouse_position().y > $selection_container.margin_top + 15 and get_local_mouse_position().y < $selection_container.margin_bottom and get_local_mouse_position().x > $selection_container.margin_left and get_local_mouse_position().x < $selection_container.margin_right:
				if last_selected_button != selected_button:
					$selection_container/AudioStreamPlayer.play()
					last_selected_button = selected_button
				$selection_container/select_fx.modulate = Color.white
				
			else:
				selected_button = null
				$selection_container/select_fx.modulate = $selection_container/select_fx.modulate.linear_interpolate(Color.transparent,delta * 5)
				
			for i in range(selection_button.size()):
				selection_button[i].rect_position = selection_button[i].rect_position.linear_interpolate($selection_container/Position2D.position + Vector2(0, 15 + i * 10),delta * 15)
				selection_button[i].modulate = Color.gray
				selection_button[i].show()
				if get_local_mouse_position().y > selection_button[i].rect_position.y and get_local_mouse_position().y < selection_button[i].rect_position.y + 10 and get_local_mouse_position().x > $selection_container.margin_left and get_local_mouse_position().x < $selection_container.margin_right:
					selected_button = selection_button[i]
					hovered_index = i
			
			if selected_button != null:
				$selection_container/select_fx.rect_position.y += (selected_button.rect_position.y - $selection_container/select_fx.rect_position.y) * 0.4
				selected_button.modulate = Color.white
				selected_button.rect_position.x += 0.6
			
			
			$selection_container.rect_size.y += (20 + selection_button.size() * 10 - $selection_container.rect_size.y) * 0.2
			$selection_container.rect_size.x += (15 + biggest_size - $selection_container.rect_size.x) * 0.2
			
			$ColorRect.hide()
		else:
			$selection_container/select_fx.modulate = Color.transparent
			$selection_container/text.show()
			
			rect_size.y += (15 - rect_size.y) * 0.1
			
#			show_on_top = false
			
			$selection_container.rect_size.y += (13 - $selection_container.rect_size.y) * 0.2
			$selection_container.rect_size.x += ((20 + $selection_container/text.text.length() * 5)- $selection_container.rect_size.x) * 0.2
			
			$ColorRect.show()
			
	else:
		just_hovered = true
		
		$selection_container/Control/dropdown_icon.hide()
		
		$selection_container/text.show()
		$selection_container/select_fx.modulate = Color.transparent
	
		rect_size.y += (15 - rect_size.y) * 0.1
		
		$selection_container.rect_size.y += (13 - $selection_container.rect_size.y) * 0.2
		$selection_container.rect_size.x += ((9 + $selection_container/text.text.length() * 5)- $selection_container.rect_size.x) * 0.2
		
#		show_on_top = false
		
		$ColorRect.show()
		
		
	

#var selections_text = []
#var selections = []
#
#func _ready() -> void:
#	selections_text = ResourceLoader.load(saved_text).settings.values()[index]
##	{}.values().
#
#	for i in range(selections_text.size()):
#		var selection = $selection_container/selection.duplicate()
#		selection.get_node("text").text = selections_text[i]
#		$selection_container.add_child(selection)
#		selections.append(selection)
#
#	$selection_container/selection.queue_free()
#	var accumulated_sizes = 0
#
#	for i in range(selections.size()):
#		selections[i].rect_position =  selections[i - 1].rect_position + Vector2(selections[i - 1].get_node("text").text.length() * 7 , 0)
#		accumulated_sizes += selections[i].rect_position.x + selections[i].get_node("text").text.length() * 5
#
#	for i in range(selections.size()):
#		selections[i].rect_position.x -= accumulated_sizes / (selections_text.size() * 1.5)
#
#func _physics_process(delta: float) -> void:
#	if hovered:
#		for i in range(selections.size()):
#			var p = selections[i]
#			if get_global_mouse_position().x > p.rect_global_position.x + 3 and get_global_mouse_position().x < p.rect_global_position.x + p.rect_size.x - 20:
#				p.modulate = Color.white
#			else:
#				p.modulate = Color.darkgray
