extends Node2D
@onready var card_menino = $cardMenino
@onready var card_menina = $cardMenina
@onready var botao_sortear = $botaoSortear
@onready var label_resultado = $LabelResultado
@onready var botao_comecar = $botaoComecar
@onready var som_jogador1_sorteado = $jogador1Sorteado
@onready var som_jogador2_sorteado = $jogador2Sorteado
@onready var som_anuncio_sorteio = $anuncioSorteio
@onready var som_botao_confirmar_corrida = $botaoConfirmarCorrida
var sorteando = false
var card_sorteado = -1
func _ready() -> void:
	botao_sortear.pressed.connect(_sortear)
	botao_comecar.pressed.connect(_comecar)
	label_resultado.text = ""
	botao_comecar.visible = false
	som_anuncio_sorteio.play()
func _sortear() -> void:
	if sorteando:
		return
	sorteando = true
	botao_sortear.disabled = true
	label_resultado.text = ""
	botao_comecar.visible = false
	card_sorteado = randi() % 2
	await _animar_sorteio()
	sorteando = false
	botao_sortear.disabled = false
func _animar_sorteio() -> void:
	var duracao = 2.0
	var velocidade = 15.0
	var tempo = 0.0
	var amplitude = 20.0
	while tempo < duracao:
		var t = tempo / duracao
		var fator = 1.0 - t
		var angulo = sin(tempo * velocidade) * amplitude * fator
		card_menino.rotation_degrees = angulo
		card_menina.rotation_degrees = -angulo
		tempo += get_process_delta_time()
		await get_tree().process_frame
	card_menino.rotation_degrees = 0
	card_menina.rotation_degrees = 0
	await _piscar_resultado()
func _piscar_resultado() -> void:
	for i in range(4):
		card_menino.modulate.a = 0.3
		card_menina.modulate.a = 0.3
		await get_tree().create_timer(0.1).timeout
		card_menino.modulate.a = 1.0
		card_menina.modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout
	var jogador_que_comeca = ""
	if card_sorteado == GameData.jogador1_personagem:
		jogador_que_comeca = "JOGADOR 1"
		som_jogador1_sorteado.play()
		som_jogador1_sorteado.finished.connect(_tocar_confirmar_corrida, CONNECT_ONE_SHOT)
	else:
		jogador_que_comeca = "JOGADOR 2"
		som_jogador2_sorteado.play()
		som_jogador2_sorteado.finished.connect(_tocar_confirmar_corrida, CONNECT_ONE_SHOT)
	GameData.jogador_que_comeca = jogador_que_comeca
	if card_sorteado == 0:
		card_menino.modulate = Color(0.5, 1.0, 0.5)
		card_menina.modulate = Color(1.0, 1.0, 1.0)
		label_resultado.text = "Card do MENINO sorteado!\n" + jogador_que_comeca + " começa!"
	else:
		card_menina.modulate = Color(0.5, 1.0, 0.5)
		card_menino.modulate = Color(1.0, 1.0, 1.0)
		label_resultado.text = "Card da MENINA sorteado!\n" + jogador_que_comeca + " começa!"
	botao_comecar.visible = true
func _tocar_confirmar_corrida() -> void:
	som_botao_confirmar_corrida.play()
func _comecar() -> void:
	get_tree().change_scene_to_file("res://cenarioPrincipal.tscn")
