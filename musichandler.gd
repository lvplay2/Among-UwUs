extends Node





var MusicHandlerScene = preload("res://musichandlerscene.tscn").instance()
var canPlayMusic = true


func _ready():
	get_tree().get_root().call_deferred("add_child", MusicHandlerScene)
	MusicHandlerScene.stream = load("res://Sound/music/ingame/slowambient.ogg")
	MusicHandlerScene.play()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)


func StopMusic():
	if canPlayMusic == false:
		MusicHandlerScene.stop()
	else :
		MusicHandlerScene.play()




