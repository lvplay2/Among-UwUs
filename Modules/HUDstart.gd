extends CanvasLayer


func _ready():
	Musichandler.canPlayMusic = false
	Musichandler.StopMusic()
	Globals.ToggleChat(false)
	if (Globals.youreimpostor == false):
		$Control / IMPOSTORSCREEN.frame = 1
		$Control / spheregradient.modulate = Color(0, 0.27, 0.37, 1)
	else :
		$Control / IMPOSTORSCREEN.frame = 0
		$Control / spheregradient.modulate = Color(0.233, 0, 0, 1)
	
	$AnimationPlayer.play("StartScreen")
	$CinematicHitSound.play()

func LoadMap():
	get_parent().get_node("game").get_node("YSort").add_child(load("res://MainLevel.tscn").instance())
