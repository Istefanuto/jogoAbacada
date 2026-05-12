extends Label
func _ready() -> void:
	var fonte = load("res://heartland-sans-bold.otf")
	add_theme_font_override("font", fonte)
	add_theme_font_size_override("font_size", 35)
	add_theme_color_override("font_color", Color(0.15, 0.45, 0.2))
	add_theme_color_override("font_outline_color", Color(0.95, 0.88, 0.7))
	add_theme_constant_override("outline_size", 14)
	add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.0))
	add_theme_constant_override("shadow_offset_x", 0)
	add_theme_constant_override("shadow_offset_y", 0)
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text = ""
