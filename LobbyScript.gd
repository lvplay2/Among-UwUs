extends Node2D








func _ready():
	$AnimationPlayer.play("LobbyAnim")

func Remove():
	$AnimationPlayer.queue_free()
	$YSort / cubes.queue_free()
	$Player1Pos.queue_free()
	$lobbyfinal.queue_free()
	$YSort / cubes2.queue_free()
	$YSort / cubes3.queue_free()
	$YSort / cubes4.queue_free()
	$Area2D.queue_free()
	$Light1.queue_free()
	$Light2.queue_free()
	$SpaceLayer1.queue_free()



