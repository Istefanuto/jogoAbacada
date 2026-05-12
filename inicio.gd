extends Node

var mouse_dentro = false

func _ready() -> void:
	Menu.telaInicial = true

	if GameData.Intro_tocar == true:
		GameData.Intro_tocar = false
		await get_tree().create_timer(3.3).timeout
	$Intro.visible = false

	Audios.tocar_instrucao("res://assets/audios/como_jogar/somInicialJogo.mp3")

func _on_jogar_pressed() -> void:
	reset_dados()
	get_tree().change_scene_to_file("res://escolhaPersonagem.tscn")

func reset_dados():
	GameData.Score = 0
	GameData.erros = 0
	GameData.TempoDeJogo_Min = 0
	GameData.TempoDeJogo_Sec = 0
	GameData.JogoConcluido = false

func _on_jogar_mouse_entered() -> void:
	mouse_dentro = true
	$Timer.start()

func _on_jogar_mouse_exited() -> void:
	mouse_dentro = false
	$Timer.stop()

func _on_timer_timeout() -> void:
	Audios.tocar_audio("res://assets/audios/jogar.ogg", self)
	$Timer.stop()

func _on_timer_instrucao_timeout() -> void:
	Audios.tocar_instrucao("res://assets/audios/tela_inicial.ogg")

func is_mouse_inside() -> bool:
	return mouse_dentro
