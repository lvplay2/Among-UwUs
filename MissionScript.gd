extends StaticBody2D








func _ready():
	pass






func Quest():
	Globals.CurrentTask = load("res://Tasks/DefaultCubeTask.tscn").instance()
	Globals.CurrentTask.SetAreaToDestroy(self)
	get_tree().get_root().add_child(Globals.CurrentTask)

func _on_Quests1_body_entered(body):
	if body.has_method("ActualizarListaJugadoresEnRadio"):
		print("Entered UwU")


func _on_Quests1_body_exited(body):
	pass
