extends Node2D
var jogador1_escolha: int = -1
var jogador2_escolha: int = -1
var turno_atual: int = 1
@onready var btn_selecionar_1 = $BtnSelecionar1
@onready var btn_selecionar_2 = $BtnSelecionar2
@onready var btn_confirmar = $BtnConfirmar
@onready var label_turno = $LabelTurno
@onready var som_jogador1_escolha = $somJogador1Escolha
@onready var som_jogador2_escolha = $somJogador2Escolha
@onready var som_personagem_ja_escolhido = $somPersonagemjaEscolhido
@onready var som_clique_continuar = $cliqueEmContinuar
func _ready() -> void:
	btn_selecionar_1.pressed.connect(_selecionar_personagem.bind(0))
	btn_selecionar_2.pressed.connect(_selecionar_personagem.bind(1))
	btn_confirmar.pressed.connect(_confirmar)
	btn_confirmar.disabled = true
	som_jogador1_escolha.play()
	_atualizar_label()
func _selecionar_personagem(personagem_id: int) -> void:
	if turno_atual == 1:
		jogador1_escolha = personagem_id
		turno_atual = 2
		som_jogador2_escolha.play()
	elif turno_atual == 2:
		if personagem_id == jogador1_escolha:
			label_turno.text = "PERSONAGEM JÁ ESCOLHIDO! ESCOLHA OUTRO."
			som_personagem_ja_escolhido.play()
			return
		jogador2_escolha = personagem_id
		turno_atual = 0
		btn_confirmar.disabled = false
		som_clique_continuar.play()
	_atualizar_label()
func _atualizar_label() -> void:
	if turno_atual == 1:
		label_turno.text = "JOGADOR 1 \n ESCOLHA SEU PERSONAGEM!"
	elif turno_atual == 2:
		label_turno.text = "JOGADOR 2 \n ESCOLHA SEU PERSONAGEM!"
	else:
		label_turno.text = "PRONTOS! CLIQUE EM CONFIRMAR."
func _confirmar() -> void:
	GameData.jogador1_personagem = jogador1_escolha
	GameData.jogador2_personagem = jogador2_escolha
	get_tree().change_scene_to_file("res://sorteioParaComeçar.tscn")
