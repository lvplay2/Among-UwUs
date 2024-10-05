extends CanvasLayer





var players = []
var buttons = ["Button1", "Button2", "Button3", "Button4", "Button5", "Button6", "Button7", "Button8", "Button9", "Button10"]
var fetchedPlayers = []
var fetchedPlayersName = []
var PlayersVoted = []
var playerslefttovote = 10
var HaveIVoted = false
var MostVotedNumber = 0
var MostVotedPlayerID = 0


func _ready():
	Globals.ToggleChat(true)
	players = get_parent().get_node("game").get_node("YSort").get_node("Players").get_children()
	var a = 0
	for i in players:
		if i.IsDed == false:
			get_node(buttons[a]).text = i.player_name
			get_node(buttons[a]).self_modulate = i.get_node("Sprite").self_modulate
			get_node(buttons[a]).disabled = false
			fetchedPlayers.append(i)
			fetchedPlayersName.append(i.name)
			a = a + 1
		else :
			
			if i.has_node("CollisionShape"):
				i.get_node("CollisionShape").disabled = true
				i.get_node("AreaKill/CollisionKill").disabled = true
			else :
				i.get_node("Sprite").visible = false

				
	playerslefttovote = a
	UpdateRemaingingText()
	








		

func votePlayer(currentbutton):
	if HaveIVoted == false:
		HaveIVoted = true
		rpc("displayVoted", get_tree().get_network_unique_id(), fetchedPlayers[currentbutton].name)

remotesync func displayVoted(NetworkdID, votedplayer):
	for i in fetchedPlayers:
		if i.name == str(NetworkdID):
			var currentbutton = get_node(buttons[fetchedPlayers.find(i, 0)]).get_child(0)
			playerslefttovote -= 1
			currentbutton.visible = true
			PlayersVoted.append(votedplayer)

			var y = 0
			while y < PlayersVoted.size():
				print(PlayersVoted.count(PlayersVoted[y]))
				if PlayersVoted.count(PlayersVoted[y]) > MostVotedNumber:
					MostVotedNumber = PlayersVoted.count(PlayersVoted[y])
					MostVotedPlayerID = PlayersVoted[y]
				y += 1
			UpdateRemaingingText()
	
func UpdateRemaingingText():
	$VotesRemaining.text = str(playerslefttovote) + " players left to vote."
	if playerslefttovote <= 0:
		rpc_id(int(MostVotedPlayerID), "CheckIfImpostor")

	pass

remotesync func CheckIfImpostor():
	rpc("ShowKickedPlayer", Globals.youreimpostor)

remotesync func ShowKickedPlayer(IsImpostor):
	var Kickingplayer = load("res://Interfaz/Kickingplayer.tscn").instance()
	get_parent().add_child(Kickingplayer)
	self.queue_free()
	Kickingplayer.BeginAnimation(MostVotedPlayerID, IsImpostor, fetchedPlayers.size())

func _on_Button1_pressed():
	votePlayer(0)



func _on_Button2_pressed():
	votePlayer(1)


func _on_Button3_pressed():
	votePlayer(2)


func _on_Button4_pressed():
	votePlayer(3)


func _on_Button5_pressed():
	votePlayer(4)
	
func _on_Button6_pressed():
	votePlayer(5)

func _on_Button7_pressed():
	votePlayer(6)

func _on_Button8_pressed():
	votePlayer(7)

func _on_Button9_pressed():
	votePlayer(8)

func _on_Button10_pressed():
	votePlayer(9)
