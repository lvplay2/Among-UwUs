extends CanvasLayer





var WasTheImpostor = false
var PlayersLeft = 10


func _ready():

	pass

func BeginAnimation(PlayerID, IsImpostor, FetchedPlayers):
	WasTheImpostor = IsImpostor
	PlayersLeft = FetchedPlayers
	var PlayerKicked = FindPlayer(PlayerID)
	print("The impostor is " + str(Globals.impostor))
	print("The current player ID is" + PlayerID)
	if IsImpostor == true:
		$WasTheImpostorLabel.text = PlayerKicked.player_name + (" was the impostor")
	else :
		$WasTheImpostorLabel.text = PlayerKicked.player_name + (" was not the impostor")
	$furro.self_modulate = PlayerKicked.get_node("Sprite").self_modulate
	$furro / tail.self_modulate = PlayerKicked.get_node("Sprite/Tail").self_modulate
	$KickedAnimation.play("kickedanim")
	PlayerKicked.SpawnDeadPlayer(PlayerID, Vector2(1000, 1000), 1)
	PlayerKicked.get_node("CollisionShape").disabled = true
	PlayerKicked.get_node("AreaKill/CollisionKill").disabled = true
	



func EndAnimation():
	if WasTheImpostor == true:
		Globals.DisplayWinScreen(false)
	else :
		if PlayersLeft <= 3:
			Globals.DisplayWinScreen(true)
	self.queue_free()
	Globals.CanMove = true
	Globals.KillCooldown = 30
	Globals.HUDplayer.get_node("BotonReporte").visible = true
	Globals.HUDplayer.get_node("BotonUso").visible = true
	Globals.ToggleChat(false)





func FindPlayer(player):
	return get_parent().get_node("game").get_node("YSort").get_node("Players").get_node(player)
