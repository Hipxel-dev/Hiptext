extends settings_button

var value = 0

var sfx = preload("res://click_light.wav")
var last_value = 0

var clicked = false

func _ready() -> void:
	var setup_max_value = ResourceLoader.load(saved_text).settings_value[index]
	
	if setup_max_value.size() < 2:
		$ProgressBar.max_value = setup_max_value[setup_max_value.size() - 1]

	
func _physics_process(delta: float) -> void:
	if last_value != value:
		$ProgressBar/AudioStreamPlayer.play()
		last_value = value
	$ProgressBar/NinePatchRect.rect_position.x += ((value / $ProgressBar.max_value) * $ProgressBar.rect_size.x - $ProgressBar/NinePatchRect.rect_position.x) * 0.6
	$ProgressBar.value += (value - $ProgressBar.value) * 0.5
	if hovered:
		if Input.is_action_pressed("CLICK"):
			clicked = true
			get_parent().dropdown_push_strength = 0
			get_parent().dropdown = true
			value = int((($ProgressBar.get_local_mouse_position().x) / $ProgressBar.rect_size.x) * $ProgressBar.max_value)
			value = clamp(value, 0, $ProgressBar.max_value)
			update_text()
	
	if get_parent().dropdown and clicked:
		if Input.is_action_just_released("CLICK"):
			get_parent().dropdown = false
			clicked = false
			
func update_text():
#	pass
	$text2.text = str(value)
