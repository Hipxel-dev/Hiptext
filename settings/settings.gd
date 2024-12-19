extends Control

var saved_text = "user://debug_list.tres"

var slider = preload("res://settings/slider_button.tscn")
var seperator = preload("res://settings/Seperator.tscn")
var checkbox = preload("res://settings/checkbox_button.tscn")
var selection = preload("res://settings/selection_button.tscn")
var button = preload("res://settings/option_button_button.tscn")

var last_selection_index = 0
var selection_index = 0
var buttons = []

var scroll = 0
var toggler = false

var dropdown = false
var button_in_dropdown = 0
var dropdown_push_strength = 0

onready var elements = [$Sprite, $Node2D, $cog, $Node2D2]
var element_pos = []

var triangles = []

var testdict = {
	"s_slider": 100,
	"t_toggle": false
}

func _input(event: InputEvent) -> void:
	if get_global_mouse_position().y > 25:
		if Input.is_action_pressed("SCROLL_DOWN"):
			scroll -= 25
		if Input.is_action_pressed("SCROLL_UP"):
			scroll += 25

# s = slider
# t = toggle
# p = seperator with title
# e = selection with arrays as texts

var last_pos = Vector2.ZERO

var toggler_1 = true
var loaded_data = null

func _ready() -> void:
	
	loaded_data = ResourceLoader.load(saved_text).settings_value
	
	for o in range(9):
		for i in range(14):
			var triangle_inst = $CPUParticles2D/Sprite.duplicate()
			triangle_inst.position = Vector2((i + (o % 2)) * 32,64 * o)
			var rand_white = rand_range(-0.3,0.3)
			triangle_inst.self_modulate = Color(rand_white,rand_white,rand_white,rand_range(0.7,1))
			toggler_1 = !toggler_1
			if toggler_1:
				$CPUParticles2D/Sprite.scale.y = 0.5
			else:
				$CPUParticles2D/Sprite.scale.y = -0.5
			$CPUParticles2D.add_child(triangle_inst)
			triangles.append(triangle_inst)
	
	$CPUParticles2D/Sprite.queue_free()
	triangles.shuffle()
	
	$CPUParticles2D.show_behind_parent = true
	for i in range(elements.size()):
		element_pos.append(elements[i].position)
		elements[i].position.x += sin(1 + i * 2) * 15555
	
	var res = ResourceLoader.load(saved_text)
	
	for i in range(res.settings.keys().size()):
		var p = res.settings.keys()[i]
		var val = res.settings.get(p)
		
		if p[0] == "t":
			var toggle_inst = checkbox.instance()
			var text = p
			text[0] = ""
			toggle_inst.key = p
			toggle_inst.index = i
			toggle_inst.get_node("text").text = text
			buttons.append(toggle_inst)
			add_child(toggle_inst)
		if p[0] == "s":
			var slider_inst = slider.instance()
			var text = p
			text[0] = ""
			slider_inst.key = p
			slider_inst.index = i
			slider_inst.get_node("text").text = text
			buttons.append(slider_inst)
			add_child(slider_inst)
		if p[0] == "p":
			var seperator_inst = seperator.instance()
			var text = p
			text[0] = ""
			if val:
				seperator_inst.hide()
			seperator_inst.get_node("text").text = text
			buttons.append(seperator_inst)
			add_child(seperator_inst)
		if p[0] == "e":
			var selection_inst = selection.instance()
			var text = p
			text[0] = ""
			selection_inst.key = p
			selection_inst.index = i
			selection_inst.get_node("text").text = text
			buttons.append(selection_inst)
			add_child(selection_inst)
		if p[0] == "b":
			var button_inst = button.instance()
			var text = p
			text[0] = ""
			button_inst.key = p
			button_inst.index = i
			button_inst.get_node("text").text = text
			buttons.append(button_inst)
			add_child(button_inst)
			
			
	for i in range(buttons.size()):
		toggler = !toggler
		
		buttons[i].rect_position = $anchor.position + Vector2(0, 15  *i)
		if toggler:
			buttons[i].rect_position.x -= 1000 * (i + 0)
		else:
			buttons[i].rect_position.x += 2000 * (i + 0)
			
		if buttons[i].unhoverable == false:
			buttons[i].get_node("ColorRect").rect_size.y += 55 * i

func save():
	var data_to_save = ResourceLoader.load(saved_text) 
	
	data_to_save.settings_value = loaded_data
	
	ResourceSaver.save(saved_text,data_to_save)
	
	print(ResourceLoader.load(saved_text).settings_value)
	
func _physics_process(delta: float) -> void:
	$cog.rotation_degrees += 1
	
	if scroll > 0:
		scroll /= 1.3
	if scroll < -buttons.back().rect_position.y + 260:
		scroll += (-(buttons.back().rect_position.y - 260)- scroll) * 0.2
	
	rect_position.y += (scroll - rect_position.y) * 0.2
	for i in range(triangles.size()):
		triangles[i].modulate = Color(0,0,0, sin((i ) + OS.get_ticks_msec() * delta * 0.05) * 0.5)
	
	for i in range(elements.size()):
		elements[i].position = elements[i].position.linear_interpolate(element_pos[i],delta * 15)
		
		
	if last_selection_index != selection_index:
		$AudioStreamPlayer2D.play()
		last_selection_index = selection_index
	
	
	for i in range(buttons.size()):
		var p = buttons[i]
		
		if not dropdown:
			p.rect_position = p.rect_position.linear_interpolate($anchor.position + Vector2(0,i * 16 ),delta * 15)
			if get_local_mouse_position().y > p.rect_position.y  and get_local_mouse_position().y < p.rect_position.y + 16:
				p.hovered = true
				selection_index = i
			else:
				p.hovered = false
		else:
			if i < button_in_dropdown + 1:
				p.rect_position = p.rect_position.linear_interpolate($anchor.position + Vector2(0,i * 16 ),delta * 15)
			else:
				p.rect_position = p.rect_position.linear_interpolate($anchor.position + Vector2(0,dropdown_push_strength + i * 16 ),delta * 15)
				
	$CPUParticles2D.position.y += (-rect_position.y / 2 - $CPUParticles2D.position.y) * 0.5
	$CPUParticles2D.position.x /= 1.1
