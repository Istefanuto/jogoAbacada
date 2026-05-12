extends Node

var pedido_pendente: Dictionary = {}


func tocar_instrucao(caminho_instrucao: String) -> void:
	$audio.stop()
	$acertou.stop()
	$instrucao.stream = load(caminho_instrucao)
	$instrucao.play()

func tocar_audio(caminho_audio, requester: Node) -> void:
	if $instrucao.playing or $audio_botao.playing or $acertou.playing:
		pedido_pendente = { "caminho": caminho_audio, "requester": requester }
		return
	if not $audio.playing:
		if caminho_audio is String:
			$audio.stream = load(caminho_audio)
		else:
			$audio.stream = caminho_audio
		$audio.play()

func tocar_acertou():
	$acertou.play()

func audio_botao(caminho_audio):
	$instrucao.stop()
	if caminho_audio is String:
		$audio_botao.stream = load(caminho_audio)
	else:
		$audio_botao.stream = caminho_audio
	$audio_botao.play()

func _on_instrucao_finished() -> void:
	if pedido_pendente.is_empty():
		return
	var caminho = pedido_pendente.get("caminho")
	var requester = pedido_pendente.get("requester")
	pedido_pendente.clear()
	if is_instance_valid(requester) and requester.has_method("is_mouse_inside") and requester.is_mouse_inside():
		if caminho is String:
			$audio.stream = load(caminho)
		else:
			$audio.stream = caminho
		$audio.play()
