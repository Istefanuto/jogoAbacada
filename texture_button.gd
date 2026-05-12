extends TextureButton

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	disabled = true
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://escolhaPersonagem.tscn")
