extends settings_button

var result = false

func _ready() -> void:
	if ResourceLoader.load(saved_text).settings_value:
		result = true
	else:
		result = false

func _physics_process(delta: float) -> void:
	if hovered:
		if Input.is_action_just_pressed("CLICK"):
			var res = ResourceLoader.load(saved_text)
			res.settings[key] = !result
			print(res.settings[key])
			ResourceSaver.save(saved_text, res)
			
			if ResourceLoader.load(saved_text).settings.get(key):
				result = true
				rect_position.x -= 5
			else:
				rect_position.x += 5
				result = false
				
	if result:
		$toggle.rect_position = $toggle.rect_position.linear_interpolate(Vector2(284,3),delta * 15)
	else:
		$toggle.rect_position = $toggle.rect_position.linear_interpolate(Vector2(275,3),delta * 15)
	
