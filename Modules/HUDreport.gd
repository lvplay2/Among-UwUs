extends CanvasLayer


func _ready():
	$AnimationPlayer.play("ReportFade")
	$CinematicHitSound.play()

func SpawnVoting():
	get_parent().add_child(load("res://Interfaz/Voting.tscn").instance())

func SetColor(ColorMuerto):
	$Control / furro.modulate = ColorMuerto
