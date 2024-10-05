extends Node

var lobby = preload("res://Lobby.tscn").instance()
var map = preload("res://game.tscn").instance()
var servermenu = preload("res://Modules/ServerMenu.tscn").instance()
var chatmenu = preload("res://Modules/Chat.tscn").instance()
var lobbyHUD = preload("res://Modules/LobbyHUD.tscn").instance()
var HUDstart = preload("res://Modules/HUDstart.tscn").instance()
var HUDplayer = preload("res://Interfaz/HUDplayer.tscn").instance()
var HUDwin = preload("res://Interfaz/WinnerHUD.tscn").instance()
var MobileControls = preload("res://Interfaz/MobileControls.tscn").instance()
var CurrentTask = null

var GlobalMissionsCompleted = 0
var YourMissionsCompleted = 0

var KillCooldown = 10

var player_list = []
var impostor = 0
var youreimpostor = false
var CanMove = true
var IsAlive = true

var player_name = "Server"
var player_color = "red"

func _ready():
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	
	
	if "--server" in OS.get_cmdline_args():
		print("The server creation has been executed")
		create_server()
		

func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(6969, 10)
	print("The server has been created OwO")
	get_tree().set_network_peer(peer)
	load_game()
	
func join_server(ip, get_name, color):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, 6969)
	get_tree().set_network_peer(peer)
	player_name = get_name
	player_color = color
	
func load_game():
	map = preload("res://game.tscn").instance()
	get_tree().get_root().add_child(map)
	get_tree().get_root().get_node("Lobby").queue_free()

	if not get_tree().is_network_server():
		spawn_player(get_tree().get_network_unique_id())
	else :
		get_tree().get_root().add_child(servermenu)
	
	get_tree().get_root().add_child(chatmenu)
	lobbyHUD = preload("res://Modules/LobbyHUD.tscn").instance()
	get_tree().get_root().add_child(lobbyHUD)
	get_tree().get_root().add_child(MobileControls)

func spawn_player(id):
	var player = load("res://playercontroller.tscn").instance()
	var spawn = get_tree().get_root().find_node("YSort", true, false).get_node("Players")
	spawn.add_child(player)
	player.name = str(id)
	player.set_network_master(id)

func _on_network_peer_connected(id):
	if id != 1:
		spawn_player(id)
	updatePlayerList(id, false)
	
		
func updatePlayerList(playerid, hasToRemove):
	if get_tree().is_network_server():
		if (hasToRemove == false):
			player_list.append(playerid)
		else :
			player_list.remove(player_list.find(playerid, 0))
		rpc("GetPlayerList", player_list)
		
remote func GetPlayerList(list):
	player_list = list

func _on_network_peer_disconnected(id):
	if id != 1:
		get_tree().get_root().find_node(str(id), true, false).queue_free()
	updatePlayerList(id, true)

func _on_connected_to_server():
	load_game()

func _on_server_disconnected():
	get_tree().get_root().add_child(lobby)
	get_tree().get_root().get_node("game").queue_free()
	get_tree().set_network_peer(null)
	player_list = []
	youreimpostor = false

remotesync func SetLobbyHUDStart():
	HUDstart = preload("res://Modules/HUDstart.tscn").instance()
	get_tree().get_root().add_child(HUDstart)
	HUDplayer = preload("res://Interfaz/HUDplayer.tscn").instance()
	get_tree().get_root().add_child(HUDplayer)
	
func SetImpostor():
	impostor = player_list[randi() % player_list.size()]
	print(impostor)
	rpc("NotImpostor")
	if (impostor != get_tree().get_network_unique_id()):
		rpc_id(impostor, "ImTheImpostor")
	else :
		ImTheImpostor()
	rpc("SetLobbyHUDStart")
	
remotesync func NotImpostor():
	youreimpostor = false
	
remote func ImTheImpostor():
	youreimpostor = true

func DisplayWinScreen(IsImpostor):
	Musichandler.StopMusic()
	get_tree().get_root().add_child(HUDwin)
	HUDwin.start(IsImpostor)

func ToggleChat(Enable):
	if Enable == false:
		if IsAlive == true:
			Globals.chatmenu.get_node("ToggleVisibility").visible = false
			Globals.chatmenu.get_node("ChatBox").visible = false
			Globals.chatmenu.get_node("Message").visible = false
			Globals.chatmenu.get_node("BGCol").visible = false
			Globals.chatmenu.get_node("dot").visible = false
	else :
		Globals.chatmenu.get_node("ToggleVisibility").visible = true
		Globals.chatmenu.get_node("ChatBox").visible = false
		Globals.chatmenu.get_node("Message").visible = false
		Globals.chatmenu.get_node("BGCol").visible = false
		Globals.chatmenu.get_node("dot").visible = false

func MissionCompleted():
	YourMissionsCompleted += 1
	rpc("AddCompletedMission")
	
remotesync func AddCompletedMission():
	GlobalMissionsCompleted += 1
	HUDplayer.UpdateMissionCounter()
	if GlobalMissionsCompleted >= (player_list.size() * 10) - 10:
		DisplayWinScreen(false)
