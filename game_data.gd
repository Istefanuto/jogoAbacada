extends Node

var jogador1_personagem: int = -1
var jogador2_personagem: int = -1
var jogador_que_comeca: String = ""

# Controle da intro (toca só uma vez)
var Intro_tocar: bool = true

# Dados de pontuação / tempo
var Score: int = 0
var erros: int = 0
var TempoDeJogo_Min: int = 0
var TempoDeJogo_Sec: int = 0
var JogoConcluido: bool = false
