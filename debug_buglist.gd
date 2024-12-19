extends CanvasLayer

var saved_text = "user://debug_list.tres"
var quit = false

var focused = false
var reminder_mode = false

onready var tab = $Control/tab/tab.duplicate()

var size_of_all_tabs_combined = 0
var tabs = []
var current_tab_index = 0
var ms = Vector2.ZERO

var last_selected_button = null
var last_selected_button2 = null
var selected_button = null

var popup = false


func _ready() -> void:
	
	get_tree().get_root().transparent_bg = true
	offset = Vector2(320,180) * 2
	scale = Vector2(0,1311) * 2
	
	var loaded_resource = ResourceLoader.load(saved_text)
	
	if loaded_resource != null:
		ResourceSaver.save(saved_text,preload("res://buglist.tres"))

	loaded_resource.settings_value = []
	loaded_resource.settings_variable = []
	
	for i in range(loaded_resource.settings.keys().size()):
		var trimmed_texts = loaded_resource.settings.keys()[i]
		trimmed_texts[0] = ""
		
		loaded_resource.settings_value.append(loaded_resource.settings.get(loaded_resource.settings.keys()[i]))
		loaded_resource.settings_variable.append(trimmed_texts)
		
		ResourceSaver.save(saved_text, loaded_resource)
	
	
	$Control/ProgressBar.show_on_top = true
		
	for i in range(loaded_resource.saved_text.size()):
		var tabs_inst = $Control/tab/tab.duplicate()
		tabs_inst.get_node("Label").text = str(ResourceLoader.load(saved_text).text_names[i])
		tabs.append(tabs_inst)
		tabs_inst.position.x = size_of_all_tabs_combined
		tabs_inst.position.y = 12500 * i
		if i > 0:
			tabs_inst.position.y += 1000 * i
		update_tab_size()
		
		$Control/tab/tab_container.add_child(tabs_inst)
	
	$Control/tab/tab.queue_free()
	
	if tabs != []:
		$Control/TextEdit.text = str(ResourceLoader.load(saved_text).saved_text[0])
	else:
		$Control/TextEdit.text = $title.text
		$Control/TextEdit.readonly = true
		selected_button = null
		$Control/TextEdit.cursor_set_column(2)
		$Control/TextEdit.cursor_set_line(1)
	
	
	var loaded_data_with_always_updated_settings = loaded_resource
	var new_settings_data = preload("res://buglist.tres")
	loaded_data_with_always_updated_settings.settings = new_settings_data.settings
	ResourceSaver.save(saved_text, loaded_data_with_always_updated_settings)
	
	print(ResourceLoader.load(saved_text).settings_value)
	
	update_tab_size()
	
var typing_noise = preload("res://click_light.wav")

func update_tab_size():
	var default_colorrect_size_x = 20
	var default_colorrect3_size_x = 18
	var default_colorrect2_size_x = 18
	var updated_res = ResourceLoader.load(saved_text)
	size_of_all_tabs_combined = 0
	
	for i in range(tabs.size()):
		var p = tabs[i]
		var calculated_addition = -6 + p.get_node("Label").text.length() * 5
		p.get_node("ColorRect").rect_size.x = default_colorrect_size_x + calculated_addition
		p.get_node("ColorRect/ColorRect3").rect_size.x = default_colorrect3_size_x + calculated_addition
		p.get_node("ColorRect2").rect_size.x = default_colorrect2_size_x + calculated_addition
		p.get_node("Label/next").position.x = 15 + p.get_node("Label").text.length() * 5
		size_of_all_tabs_combined += p.get_node("Label/next").position.x
		updated_res.text_names[i] = p.get_node("Label").text
		

	ResourceSaver.save(saved_text,updated_res)

var scroll = 0

func _input(event: InputEvent) -> void:
	
	if tabs != []:
		if event is InputEventKey and event.is_pressed():
			var resource_text = ResourceLoader.load(saved_text)
			resource_text.saved_text[current_tab_index] = $Control/TextEdit.text
			ResourceSaver.save(saved_text, resource_text)
			$typing_noise.play()
			
	if last_selected_button != selected_button:
		$typing_noise2.play()
		last_selected_button = selected_button
		
#	if Input.is_action_just_pressed("CLICK"):
#		fx.fx_box($Control.get_local_mouse_position(),0,0, 5,5)
	
	
	
	if popup == false:
		if selected_button != null:
			if Input.is_action_just_pressed("SCROLL_UP"):
				scroll(25)
			if Input.is_action_just_pressed("SCROLL_DOWN"):
				scroll(-25)
		
			if Input.is_action_pressed("MIDDLE_CLICK"):
				remove_tab(selected_button)
		
		if Input.is_action_pressed("CTRL"):
			if Input.is_action_just_pressed("T"):
				add_tab()
				change_tab(tabs.size() - 1)
			
			if Input.is_action_just_pressed("EXPORT"):
				popup_ui("Do you want to export current text?")

			if Input.is_action_just_pressed("OPTIONS"):
				add_tab(true)
				update_tab_size()
				if get_tree().get_nodes_in_group("Settings") == []:
					$Control/TextEdit.add_child(settings.instance())
				
	if Input.is_action_just_pressed("CLICK"):
		$typing_noise.play()
	if Input.is_action_just_released("CLICK"):
		$typing_noise2.play()
		
var popup_scene = preload("res://settings/popup.tscn")
func popup_ui(text = "lmfao", context = 0):
	popup = true
	var popup_scene_inst = popup_scene.instance()
	popup_scene_inst.get_node("Control/rect/Label").text = text
	popup_scene_inst.context = context
	$Control.add_child(popup_scene_inst)

func scroll(how_much = 0):
	scroll += how_much

func _physics_process(delta: float) -> void:
	ms = $Control/tab.get_local_mouse_position()
	
	if $Control/tab/Position2D.position.x > 5:
		 $Control/tab/Position2D.position.x += (5 - $Control/tab/Position2D.position.x) * 0.2

	if $Control/tab/Position2D.position.x < -size_of_all_tabs_combined:
		 $Control/tab/Position2D.position.x += (-(tabs.size() * 22) - $Control/tab/Position2D.position.x) * 0.2
	
	$Control/tab/tab_container.rect_position.x += (scroll - $Control/tab/tab_container.rect_position.x) * 0.3
	
	for i in range(tabs.size()):
		var p = tabs[i]
		var offsets = 0

		var resulting_pos = (tabs[i - 1].position.x)+ tabs[i - 1].get_node("Label/next").position.x 

		if i == 0:
			resulting_pos = $Control/tab/Position2D.position.x
		
		p.pos.x = resulting_pos
#		tabs[i].position = tabs[i].position.linear_interpolate($Control/tab/Position2D.position + Vector2(i * tabs[i - 1].get_node("ColorRect").rect_size.x,0),delta * 15)
		
#		var spacing = 0
#		spacing = tabs[i - 1].get_node("Label/next").position.x + tabs[i].position.x - 4
#		if i == 0:
#			spacing = 0
		
#		tabs[i].position = tabs[i].position.linear_interpolate($Control/tab/Position2D.position + Vector2(spacing,0),delta * 15)
		
		if i != current_tab_index:
			p.position.y += 0.5
			p.z_index = -1
#			if ms.y > $Control/tab.rect_position.y + 40:
#				p.position.y += 5
#			var pusher = (tabs[current_tab_index].position - tabs[i].position).normalized() * 1
#			tabs[i].position.x -= (pusher.x - 15)
		else:
			p.position.y -= 2
			p.z_index = 0
		
		if ms.y < $Control/tab.rect_position.y + 40:
			if ms.y < p.position.y + 10 and ms.y > p.position.y - 10:
				if ms.x > p.global_position.x - 5 and ms.x < p.global_position.x + 10 + p.get_node("Label").text.length() * 5 and ms.x < $Control/tab.rect_size.x:
					if i != current_tab_index:
						p.position.y += -0.7
					p.get_node("ColorRect").modulate = Color.white
					selected_button = i
				else:
					
					p.get_node("ColorRect").modulate = Color.darkgray
			else:
				p.get_node("ColorRect").modulate = Color.darkgray
		else:
			p.get_node("ColorRect").modulate = Color.darkgray
			selected_button = null
	
	if ms.x < 479:
		$Control/settings_popup/Button3.rect_position.x -= 4
	$Control/settings_popup/Button3.rect_global_position = $Control/settings_popup/Button3.rect_global_position.linear_interpolate(Vector2(480,28),delta * 15)
	
	if Input.is_action_just_pressed("CTRL"):
		print(ResourceLoader.load(saved_text).settings_value)
	
	if $Control/ProgressBar.value < 3:
		$Control/ProgressBar.modulate = $Control/ProgressBar.modulate.linear_interpolate(Color.transparent,delta * 15)
	else:
		$Control/ProgressBar.modulate = $Control/ProgressBar.modulate.linear_interpolate(Color.white,delta * 15)
	
	$Control/ProgressBar.rect_position = $Control.get_local_mouse_position() - Vector2(10,-10)
	
	if popup == false:
		if selected_button != null:
			if Input.is_action_just_pressed("CLICK"):
				change_tab(selected_button)
			if Input.is_action_just_released("CLICK"):
				if selected_button == last_selected_button2:
					tabs[selected_button].get_node("Label").editable = true
				if last_selected_button2 != selected_button:
					last_selected_button2 = selected_button
			if Input.is_action_pressed("ALT_CLICK"):
				$Control/ProgressBar.value += 5
	#			fx.sfx_non_positional(typing_noise, 1 + $Control/ProgressBar.value / 20, 1 + $Control/ProgressBar.value / 10)
				if $Control/ProgressBar.value > 99:
					remove_tab(selected_button)
					$Control/ProgressBar.value = 0
	#				fx.sfx_non_positional(typing_noise,15, 2)
			else:
				$Control/ProgressBar.value /= 1.1
		else:
			$Control/ProgressBar.value /= 1.1
		
		if tabs != []:
			if ms.y > $Control/tab.rect_position.y + 40:
				$Control/tab/add_tab.position.y += 5
			tabs[current_tab_index].get_node("ColorRect").modulate = Color.white
			$Control/tab/add_tab.position = $Control/tab/add_tab.position.linear_interpolate(Vector2(20 + tabs.back().global_position.x + tabs.back().get_node("Label").text.length() * 5,22), delta * 15)
		else:
			$Control/tab/add_tab.position = $Control/tab/add_tab.position.linear_interpolate($Control/tab/Position2D.global_position + Vector2(5,5),delta * 15)
		
		
		if $Control/tab/add_tab.global_position.distance_squared_to($Control.get_local_mouse_position()) < 100:
			$Control/tab/add_tab.scale = $Control/tab/add_tab.scale.linear_interpolate(Vector2.ONE / 1.8, delta * 25)
			$Control/tab/add_tab.modulate = Color.white
			if Input.is_action_just_pressed("CLICK"):
				add_tab()
		else:
			$Control/tab/add_tab.modulate = Color.darkgray
			
			$Control/tab/add_tab.scale = $Control/tab/add_tab.scale.linear_interpolate(Vector2.ONE / 2, delta * 25)
		$Control/TextEdit/grdnt.position = $Control/TextEdit/grdnt.position.linear_interpolate(Vector2(182,375),delta * 3)
		
		if Input.is_action_just_pressed("ui_cancel"):
			quit = true
			get_tree().quit()
			remove_from_group("buglist")
			
		if quit:
	#		global.player_pause = false
			get_tree().paused = false
			offset.x += (800 - offset.x) * 0.4
			if offset.x > 640:
				queue_free()
	else:
		$Control/TextEdit.readonly = true
			
	offset = offset.linear_interpolate(Vector2.ZERO,delta * 15)
	scale = scale.linear_interpolate(Vector2.ONE,delta * 15)

func add_tab(settings = false):
	$Control/TextEdit.readonly = false
	
	var tab_inst = tab.duplicate()
	
	if tabs != []:
		tab_inst.global_position.x = size_of_all_tabs_combined + 22
		tab_inst.global_position.y = 401
	tab_inst.get_node("Label").text = str(tabs.size())
	
	var res = ResourceLoader.load(saved_text)
	
	if settings == true:
		tab_inst.settings = true
		res.booleans.append(true)
	else:
		res.booleans.append(false)
		
	tabs.append(tab_inst)
	
	res.saved_text.append("")
	var title = str("Note ", tabs.size())
	
	res.text_names.append(title)
	tab_inst.get_node("Label").text = title
	
	ResourceSaver.save(saved_text,res)
	
	$Control/tab/tab_container.add_child(tab_inst)
	
	current_tab_index = tabs.size() - 1
	change_tab(current_tab_index)
	
	$Control/TextEdit.text = ""
	update_tab_size()
	
	var unused_settings = get_tree().get_nodes_in_group("settings")
	
	if unused_settings.size() > 1:
		unused_settings.pop_back()
		
	for i in unused_settings:
		i.queue_free()
		
	
func remove_tab(at = 0):
	
	if at < tabs.size():
		if current_tab_index > tabs.size() - 2 and current_tab_index != 0:
			current_tab_index -= 1
		
		var tab_to_free = tabs[at]

#		fx.fx_box( $Control/TextEdit.rect_size / 2,0,140,240,149, Color.white, 0.6, 1, 0, 0.6, false, $Control/TextEdit)                    
#		fx.fx_box(tab_to_free.global_position + Vector2(10,0),1.5,2,20,20, Color.white, 0.5, 1, 0, 0.3, false, $Control)
		
		tabs.pop_at(at)
		var resource_to_change = ResourceLoader.load(saved_text)
		resource_to_change.saved_text.pop_at(at)
		resource_to_change.text_names.pop_at(at)
		resource_to_change.booleans.pop_at(at)
		tab_to_free.queue_free()
		
		ResourceSaver.save(saved_text,resource_to_change)
#		change_tab(current_tab_index)
		if tabs == []:
			$Control/TextEdit.text = $title.text
			$Control/TextEdit.readonly = true
			selected_button = null
			scroll = 0
		else:
			$Control/TextEdit.text = str(resource_to_change.saved_text[current_tab_index])
			
		change_tab(current_tab_index)
	
	update_tab_size()
func change_tab(to = 0):
	
	if tabs != []:
		if to < ResourceLoader.load(saved_text).booleans.size():
			if ResourceLoader.load(saved_text).booleans[to] == true:
				tabs[to].get_node("Label").text = "Settings"
				$Control/TextEdit.readonly = true
				update_tab_size()
				if get_tree().get_nodes_in_group("settings") == []:
					$Control/TextEdit.add_child(settings.instance())
			else:
				$Control/TextEdit.readonly = false
				
				if get_tree().get_nodes_in_group("settings"):
					get_tree().get_nodes_in_group("settings")[0].queue_free()
			
	if tabs != []:
		var resource_text = ResourceLoader.load(saved_text)
		resource_text.saved_text[current_tab_index] = $Control/TextEdit.text
		ResourceSaver.save(saved_text, resource_text)
		$typing_noise.play()
	
	if to < tabs.size():
		current_tab_index = to
		for i in range(tabs.size()):
			var p = tabs[i]
			if i != current_tab_index:
				p.get_node("ColorRect").modulate = Color.darkgray
			else:
				p.get_node("ColorRect").modulate = Color.white
		
			p.get_node("Label").editable = false
		
				
		$Control/TextEdit.text = ResourceLoader.load(saved_text).saved_text[current_tab_index]
	if last_selected_button2 != current_tab_index:
		$Control/TextEdit/grdnt.position.y = -550
		last_selected_button2 = current_tab_index
	
	update_tab_size()
#	fx.fx_box($Control/TextEdit.rect_position + $Control/TextEdit.rect_size / 2,0,0,240,155, Color.white, 0.6, 1)                    
#	fx.fx_box( $Control/TextEdit.rect_size / 2,0,140,240,149, Color.white, 0.6, 1, 0, 0.6, false, $Control/TextEdit)                    
	
func _on_Button_pressed() -> void:
	quit = true
	get_tree().quit()
	
func _on_TextEdit_focus_entered() -> void:
	focused = true

func _on_TextEdit_focus_exited() -> void:
	focused = false

func _on_Label_text_changed(_new_text: String) -> void:
	update_tab_size()

func _on_Button2_pressed() -> void:
	OS.window_minimized = true

func _on_Label_text_entered(_new_text: String) -> void:
	for i in tabs:
		i.get_node("Label").deselect()
		tabs[current_tab_index].get_node("Label").caret_position = 0
#		$Control/tab/tab/Label.caret_position = 0

var settings = preload("res://settings/settings.tscn")

func _on_Button3_pressed() -> void:
	add_tab(true)
	tabs.back().get_node("Label").text = "Settings"
	update_tab_size()
	if get_tree().get_nodes_in_group("Settings") == []:
		$Control/TextEdit.add_child(settings.instance())
