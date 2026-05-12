extends Node

var cartas = [
	{"palavra": ["CA", "SA"], "imagem": "res://CARTA CASA.png", "faltante": 0, "erradas": ["BA", "MA"]},
	{"palavra": ["CA", "MA"], "imagem": "res://CARTA CAMA.png", "faltante": 1, "erradas": ["LA", "NA"]},
	{"palavra": ["BA", "LA"], "imagem": "res://CARTA BALA.png", "faltante": 0, "erradas": ["CA", "FA"]},
	{"palavra": ["GA", "TA"], "imagem": "res://CARTA GATA.png", "faltante": 0, "erradas": ["PA", "MA"]},
	{"palavra": ["BA", "NA", "NA"], "imagem": "res://CARTA BANANA.png", "faltante": 1, "erradas": ["CA", "FA"]},
	{"palavra": ["FA", "DA"], "imagem": "res://CARTA FADA.png", "faltante": 0, "erradas": ["MA", "CA"]},
	{"palavra": ["VA", "CA"], "imagem": "res://CARTA VACA.png", "faltante": 0, "erradas": ["FA", "BA"]},
	{"palavra": ["MA", "PA"], "imagem": "res://CARTA MAPA.png", "faltante": 1, "erradas": ["LA", "CA"]},
	{"palavra": ["FA", "CA"], "imagem": "res://CARTA FACA.png", "faltante": 0, "erradas": ["MA", "BA"]},
]

var fila: Array = []

func _ready() -> void:
	embaralhar()

func embaralhar() -> void:
	fila = cartas.duplicate()
	fila.shuffle()

func proxima_carta() -> Dictionary:
	if fila.is_empty():
		var ultima = fila.back() if not fila.is_empty() else {}
		embaralhar()
		if not fila.is_empty() and fila[0] == ultima:
			fila.append(fila.pop_front())
	return fila.pop_front()
