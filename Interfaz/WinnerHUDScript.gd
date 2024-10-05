extends CanvasLayer

func start(IsImpostor):
	if IsImpostor == true:
		$WINNERSCREEN.frame = 0
		$SphereGradient.modulate = Color(1, 0, 0, 0.466667)
		$WinnerSoundPlayer.stream = load("res://Sound/hud/hunterWin.ogg")
	else :
		$WINNERSCREEN.frame = 1
		$SphereGradient.modulate = Color(0, 0.53125, 1, 0.466667)
		$WinnerSoundPlayer.stream = load("res://Sound/hud/furriesWin.ogg")
	$AnimationPlayer.play("WinnerScreenAnim")
	$WinnerSoundPlayer.play()
