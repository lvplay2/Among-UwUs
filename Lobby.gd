extends Node2D













func _ready():
	$CanvasLayer / StarsAnimation.play("StarsAnim")

func _on_ButtonHost_pressed():
	Globals.create_server()
	print("hosting")


func _on_ButtonJoin_pressed():
	Globals.join_server($CanvasLayer / IP.text, $CanvasLayer / PlayerNameText.text, $CanvasLayer / Color.text)
	
func _on_Button_pressed():
	Musichandler.canPlayMusic = not Musichandler.canPlayMusic
	Musichandler.StopMusic()

