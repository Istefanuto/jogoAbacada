extends Node

var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)

	player.stream = load("res://musicaTema.mp3")
	player.autoplay = true
	player.stream.loop = true
	player.bus = &"Música"
	player.play()
	player.volume_db = -20
