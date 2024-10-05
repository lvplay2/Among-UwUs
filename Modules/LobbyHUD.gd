extends CanvasLayer





func _ready():
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	
func _on_network_peer_connected(id):
	update(id)

func _on_network_peer_disconnected(id):
	update(id)


func update(id):
	yield (get_tree(), "idle_frame")
	$Players.set_text(str(get_tree().get_network_connected_peers().size()) + "/10")

	if (get_tree().get_network_unique_id() == Globals.player_list[0]):
		$StartButton.visible = true
	else :
		$StartButton.visible = false

remotesync func StartGame():
	queue_free()
	get_parent().get_node("game").Remove()

	
func MostrarStart():
	$StartButton.visible = true






func _on_Button_pressed():
	if (get_tree().get_network_unique_id() == Globals.player_list[0]):
		Globals.SetImpostor()
		rpc("StartGame")
	
