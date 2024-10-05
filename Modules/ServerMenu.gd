extends Control

var spawn_node = null
var PlayerList = []
var RemotePlayerList = []

func _ready():
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	
func _on_network_peer_connected(id):
	update()

func _on_network_peer_disconnected(id):
	update()

func update():
	yield (get_tree(), "idle_frame")
	
	spawn_node = get_tree().get_root().find_node("YSort", true, false).get_node("Players")

	for child in get_node("ConnectedList").get_children():
		child.queue_free()
		
	for child in spawn_node.get_children():
		display_player(child.player_name)

	
	
func display_player(player_name):
	yield (get_tree(), "idle_frame")
	var HBox = HBoxContainer.new()
	$ConnectedList.add_child(HBox)

	var button = Button.new()
	button.text = "Kick"
	HBox.add_child(button)

	var player_connected = Label.new()
	player_connected.text = "- " + player_name
	HBox.add_child(player_connected)
	


func _on_Button_pressed():
	print(PlayerList)
	pass
	
	
