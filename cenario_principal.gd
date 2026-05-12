extends Node2D

@onready var personagem_menino = $personagemMenino
@onready var personagem_menina = $personagemMenina
@onready var tela_opcoes = $telaOpcoes
@onready var carta_sprite = $telaOpcoes/Carta
@onready var label_palavra = $telaOpcoes/LabelPalavra
@onready var btn_silaba_1 = $BtnSilaba1
@onready var btn_silaba_2 = $BtnSilaba2
@onready var btn_silaba_3 = $BtnSilaba3
@onready var vez_menino = $vezPersonagemMenino
@onready var vez_menina = $vezPersonagemMenina
@onready var dado_menino = $DadoMenino
@onready var dado_menino_1 = $DadoMenino/dadoMenino1
@onready var dado_menino_2 = $DadoMenino/dadoMenino2
@onready var dado_menina = $dadoMenina
@onready var dado_menina_1 = $dadoMenina/dadoMenina1
@onready var dado_menina_2 = $dadoMenina/dadoMenina2
@onready var menino_nadando = $meninoNadando
@onready var menina_nadando = $meninaNadando
@onready var menino_onda = $meninoOnda
@onready var menina_onda = $meninaOnda
@onready var menino_estrela = $meninoEstrela
@onready var menina_estrela = $meninaEstrela
@onready var menino_venceu = $meninoVenceu
@onready var menina_venceu = $meninaVenceu
@onready var label_vencedor = $LabelVencedor
@onready var som_erro = $somErro
@onready var som_acerto = $somAcerto
@onready var som_onda = $somOnda
@onready var menino_erro = $meninoErro
@onready var menina_erro = $meninaErro
@onready var som_vez_jogador1 = $vezJogador1
@onready var som_vez_jogador2 = $vezJogador2

var jogador_atual = ""
var silaba_correta = ""
var resultado_dado = 0
var jogo_acabou = false

var casa_menino = 0
var casa_menina = 0

var onda_usada_menino = false
var onda_usada_menina = false

const CASA_PIXELS = 55
const CASA_ONDA = 3
const CASA_ESTRELA = 4
const CASA_CHEGADA = 6

func _ready() -> void:
	jogador_atual = GameData.jogador_que_comeca
	_esconder_tudo()
	await get_tree().create_timer(2.0).timeout
	_mostrar_vez()

func _esconder_tudo() -> void:
	tela_opcoes.visible = false
	vez_menino.visible = false
	vez_menina.visible = false
	dado_menino.visible = false
	dado_menina.visible = false
	dado_menino_1.visible = false
	dado_menino_2.visible = false
	dado_menina_1.visible = false
	dado_menina_2.visible = false
	menino_nadando.visible = false
	menina_nadando.visible = false
	menino_onda.visible = false
	menina_onda.visible = false
	menino_estrela.visible = false
	menina_estrela.visible = false
	menino_venceu.visible = false
	menina_venceu.visible = false
	label_vencedor.visible = false
	btn_silaba_1.visible = false
	btn_silaba_2.visible = false
	btn_silaba_3.visible = false
	menino_erro.visible = false
	menina_erro.visible = false
	personagem_menino.visible = true
	personagem_menina.visible = true

func _mostrar_vez() -> void:
	if jogo_acabou:
		return

	var eh_menino = _personagem_atual_eh_menino()
	var vez_node = vez_menino if eh_menino else vez_menina

	if jogador_atual == "JOGADOR 1":
		som_vez_jogador1.play()
	else:
		som_vez_jogador2.play()

	vez_node.visible = true
	vez_node.modulate.a = 0
	await _fade_in(vez_node)
	await get_tree().create_timer(4.0).timeout
	await _fade_out(vez_node)
	vez_node.visible = false

	_mostrar_dado()

func _fade_in(node: Node2D) -> void:
	var tempo = 0.0
	while tempo < 1.0:
		node.modulate.a = tempo
		tempo += get_process_delta_time() * 2
		await get_tree().process_frame
	node.modulate.a = 1.0

func _fade_out(node: Node2D) -> void:
	var tempo = 1.0
	while tempo > 0.0:
		node.modulate.a = tempo
		tempo -= get_process_delta_time() * 2
		await get_tree().process_frame
	node.modulate.a = 0.0

func _mostrar_dado() -> void:
	if jogo_acabou:
		return

	var eh_menino = _personagem_atual_eh_menino()

	if eh_menino:
		dado_menino.visible = true
		dado_menino_1.visible = false
		dado_menino_2.visible = false
		dado_menino.set_meta("clicavel", true)
	else:
		dado_menina.visible = true
		dado_menina_1.visible = false
		dado_menina_2.visible = false
		dado_menina.set_meta("clicavel", true)

func _input(event: InputEvent) -> void:
	if jogo_acabou:
		return
	if event is InputEventMouseButton and event.pressed:
		var eh_menino = _personagem_atual_eh_menino()
		if eh_menino and dado_menino.visible and dado_menino.has_meta("clicavel"):
			dado_menino.remove_meta("clicavel")
			dado_menino_1.visible = true
			dado_menino_2.visible = false
			await _animar_dado()
			await get_tree().create_timer(1.0).timeout
			dado_menino.visible = false
			dado_menino_1.visible = false
			dado_menino_2.visible = false
			_mostrar_carta()
		elif not eh_menino and dado_menina.visible and dado_menina.has_meta("clicavel"):
			dado_menina.remove_meta("clicavel")
			dado_menina_1.visible = true
			dado_menina_2.visible = false
			await _animar_dado()
			await get_tree().create_timer(1.0).timeout
			dado_menina.visible = false
			dado_menina_1.visible = false
			dado_menina_2.visible = false
			_mostrar_carta()

func _animar_dado() -> void:
	for i in range(12):
		dado_menino_1.visible = i % 2 == 0
		dado_menino_2.visible = i % 2 != 0
		dado_menina_1.visible = i % 2 == 0
		dado_menina_2.visible = i % 2 != 0
		await get_tree().create_timer(0.1).timeout

	resultado_dado = randi() % 2 + 1

	var caiu_no_1 = resultado_dado == 1
	dado_menino_1.visible = caiu_no_1
	dado_menino_2.visible = not caiu_no_1
	dado_menina_1.visible = caiu_no_1
	dado_menina_2.visible = not caiu_no_1

func _mostrar_carta() -> void:
	if jogo_acabou:
		return

	var carta = CartasSilabaA.proxima_carta()
	silaba_correta = carta["palavra"][carta["faltante"]]

	carta_sprite.texture = load(carta["imagem"])

	var texto = ""
	for i in range(carta["palavra"].size()):
		if i == carta["faltante"]:
			texto += "__ "
		else:
			texto += carta["palavra"][i] + " "
	label_palavra.text = texto.strip_edges()

	var opcoes = [silaba_correta] + carta["erradas"]
	opcoes.shuffle()
	btn_silaba_1.get_node("LabelSilaba").text = opcoes[0]
	btn_silaba_2.get_node("LabelSilaba").text = opcoes[1]
	btn_silaba_3.get_node("LabelSilaba").text = opcoes[2]

	btn_silaba_1.visible = true
	btn_silaba_2.visible = true
	btn_silaba_3.visible = true
	tela_opcoes.visible = true

	btn_silaba_1.pressed.connect(_verificar.bind(0), CONNECT_ONE_SHOT)
	btn_silaba_2.pressed.connect(_verificar.bind(1), CONNECT_ONE_SHOT)
	btn_silaba_3.pressed.connect(_verificar.bind(2), CONNECT_ONE_SHOT)

func _verificar(indice: int) -> void:
	var botoes = [btn_silaba_1, btn_silaba_2, btn_silaba_3]
	var escolha = botoes[indice].get_node("LabelSilaba").text

	tela_opcoes.visible = false
	btn_silaba_1.visible = false
	btn_silaba_2.visible = false
	btn_silaba_3.visible = false

	if escolha == silaba_correta:
		await _avancar_personagem()
	else:
		som_erro.play()
		var eh_menino = _personagem_atual_eh_menino()
		var erro_node = menino_erro if eh_menino else menina_erro
		await _mostrar_efeito(erro_node)
		print(jogador_atual + " errou! Fica no lugar.")
		await get_tree().create_timer(0.5).timeout
		_trocar_jogador()

func _avancar_personagem() -> void:
	var eh_menino = _personagem_atual_eh_menino()
	var casas_pixel = resultado_dado * CASA_PIXELS

	if eh_menino:
		personagem_menino.visible = false
		menino_nadando.visible = true
		menino_nadando.position = personagem_menino.position
		var alvo = menino_nadando.position + Vector2(0, -casas_pixel)
		await _mover(menino_nadando, alvo)
		menino_nadando.visible = false
		personagem_menino.position = alvo
		personagem_menino.visible = true
		casa_menino += resultado_dado
	else:
		personagem_menina.visible = false
		menina_nadando.visible = true
		menina_nadando.position = personagem_menina.position
		var alvo = menina_nadando.position + Vector2(0, -casas_pixel)
		await _mover(menina_nadando, alvo)
		menina_nadando.visible = false
		personagem_menina.position = alvo
		personagem_menina.visible = true
		casa_menina += resultado_dado

	var casa_atual = casa_menino if eh_menino else casa_menina
	var onda_ja_usada = onda_usada_menino if eh_menino else onda_usada_menina
	var vai_para_onda = (casa_atual == CASA_ONDA and not onda_ja_usada)

	if not vai_para_onda:
		som_acerto.play()

	var venceu = await _verificar_casa(eh_menino)
	if not venceu:
		await get_tree().create_timer(0.5).timeout
		_trocar_jogador()

func _verificar_casa(eh_menino: bool) -> bool:
	var casa_atual = casa_menino if eh_menino else casa_menina
	var onda_node = menino_onda if eh_menino else menina_onda
	var estrela_node = menino_estrela if eh_menino else menina_estrela
	var venceu_node = menino_venceu if eh_menino else menina_venceu
	var onda_ja_usada = onda_usada_menino if eh_menino else onda_usada_menina

	if casa_atual >= CASA_CHEGADA:
		jogo_acabou = true
		await _mostrar_efeito(venceu_node)
		venceu_node.visible = true
		venceu_node.modulate.a = 1.0
		label_vencedor.text = "Parabéns " + jogador_atual + "!\nVocê venceu! 🏆"
		label_vencedor.visible = true
		return true

	if casa_atual == CASA_ESTRELA:
		await _mostrar_efeito(estrela_node)
		var bonus_pixel = CASA_PIXELS
		if eh_menino:
			var alvo = personagem_menino.position + Vector2(0, -bonus_pixel)
			personagem_menino.visible = false
			menino_nadando.visible = true
			menino_nadando.position = personagem_menino.position
			await _mover(menino_nadando, alvo)
			menino_nadando.visible = false
			personagem_menino.position = alvo
			personagem_menino.visible = true
			casa_menino += 1
		else:
			var alvo = personagem_menina.position + Vector2(0, -bonus_pixel)
			personagem_menina.visible = false
			menina_nadando.visible = true
			menina_nadando.position = personagem_menina.position
			await _mover(menina_nadando, alvo)
			menina_nadando.visible = false
			personagem_menina.position = alvo
			personagem_menina.visible = true
			casa_menina += 1
		return await _verificar_casa(eh_menino)

	if casa_atual == CASA_ONDA and not onda_ja_usada:
		som_onda.play()
		await _mostrar_efeito(onda_node)
		if eh_menino:
			onda_usada_menino = true
			var alvo = personagem_menino.position + Vector2(0, CASA_PIXELS)
			personagem_menino.visible = false
			menino_nadando.visible = true
			menino_nadando.position = personagem_menino.position
			await _mover(menino_nadando, alvo)
			menino_nadando.visible = false
			personagem_menino.position = alvo
			personagem_menino.visible = true
			casa_menino -= 1
		else:
			onda_usada_menina = true
			var alvo = personagem_menina.position + Vector2(0, CASA_PIXELS)
			personagem_menina.visible = false
			menina_nadando.visible = true
			menina_nadando.position = personagem_menina.position
			await _mover(menina_nadando, alvo)
			menina_nadando.visible = false
			personagem_menina.position = alvo
			personagem_menina.visible = true
			casa_menina -= 1

	return false

func _mostrar_efeito(node: Node2D) -> void:
	node.visible = true
	node.modulate.a = 0
	await _fade_in(node)
	await get_tree().create_timer(2.5).timeout
	await _fade_out(node)
	node.visible = false

func _mover(node: Node2D, destino: Vector2) -> void:
	var tempo = 0.0
	var origem = node.position
	while tempo < 1.0:
		node.position = origem.lerp(destino, tempo)
		tempo += get_process_delta_time() * 1.5
		await get_tree().process_frame
	node.position = destino

func _personagem_atual_eh_menino() -> bool:
	if jogador_atual == "JOGADOR 1":
		return GameData.jogador1_personagem == 0
	else:
		return GameData.jogador2_personagem == 0

func _trocar_jogador() -> void:
	if jogo_acabou:
		return
	if jogador_atual == "JOGADOR 1":
		jogador_atual = "JOGADOR 2"
	else:
		jogador_atual = "JOGADOR 1"
	await get_tree().create_timer(1.0).timeout
	_mostrar_vez()
