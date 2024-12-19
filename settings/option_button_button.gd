extends settings_button

func _physics_process(delta: float) -> void:
	if hovered:
		$text.rect_position.x -= 1.1
