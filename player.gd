extends KinematicBody2D

var speed = 450
var player_name = ""

var direction = Vector2()
var lastdirection = Vector2()
var NameOffset = Vector2(100, 80)
var wasLeft = false
var JugadoresEnRadio = []
var JugadoresMuertos = []
var IsDed = false
var CurrentMission = null

onready var camera = get_node("Camera")
onready var PlayerName = get_node("PlayerName")
onready var PlayerSprite = get_node("Sprite")
onready var AnimTree = get_node("Sprite/AnimationTree")
onready var HUDreport = preload("res://Modules/HUDreport.tscn").instance()
onready var FootStepSoundEffect = preload("res://Sound/player/footsteps/footstep2.wav")

	



func _ready():
	$PlayerName.text = Globals.player_name
	player_name = Globals.player_name
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	yield (get_tree(), "idle_frame")
	set_physics_process(is_network_master())
	if is_network_master():
		$Camera.current = true
		rpc("share_name", Globals.player_name)
		rpc("share_color", Globals.player_color)
		OS.set_window_title("Welcome, " + Globals.player_name)
		self.light_mask = false
		$Sprite.light_mask = false
		$Sprite / Casco.light_mask = false
		$Sprite / CO2.light_mask = false
		$Sprite / Tail.light_mask = false
		$Sprite / shadowcaster.light_mask = false
		$PlayerName.light_mask = false
		get_tree().get_root().connect("size_changed", self, "ResizeWindow")
		ResizeWindow()
	else :
		$Light2D.queue_free()
		$PlayerName.set_material(load("res://Resources/Sprites/PlayerNameHideMat.tres"))
		$Sprite.set_material(load("res://Resources/Sprites/PlayerHideMat.tres"))
		
func ResizeWindow():
	$Light2D.scale.x = get_viewport_rect().size.x / 59
	

remote func _set_position(pos):
	global_transform.origin = pos
	
remotesync func _SetDirection(direction):
	$Sprite / AnimationTree.playerdir = direction.x
	SetRunningSprite(direction)
	
remotesync func share_color(color):
	
	var ColorToSet = Color(0, 1.1, 0.27, 1)
	match color:
		"red":
			ColorToSet = Color(1.37, 0.22, 0.4, 1)
		"blue":
			ColorToSet = Color(0.61, 0.94, 1.49, 1)
		"orange":
			ColorToSet = Color(1.74, 0.85, 0.6, 1)
		"green":
			ColorToSet = Color(0, 1.1, 0.27, 1)
		"purple":
			ColorToSet = Color(0.89, 0, 1.35, 1)
		"black":
			ColorToSet = Color(0.6, 0.6, 0.6, 1)
		"white":
			ColorToSet = Color(1.2, 1.2, 1.2, 1)
		"brown":
			ColorToSet = Color(0.65, 0.52, 0.29, 1)
		"yellow":
			ColorToSet = Color(1.55, 1.55, 0, 1)
		"pink":
			ColorToSet = Color(1.73, 0.73, 1.33, 1)
	$Sprite.self_modulate = ColorToSet
	$Sprite / Tail.self_modulate = ColorToSet

func _physics_process(delta):
	if Globals.CanMove == true:
		direction = Vector2()
		
		direction.x = - Input.get_action_strength("move_left") + Input.get_action_strength("move_right")
		direction.y = - Input.get_action_strength("move_up") + Input.get_action_strength("move_down")
		direction = direction.normalized()

		if direction != Vector2():
			if is_network_master():
				move_and_slide(direction * speed)
				if (IsDed == false):
					rpc_unreliable("_set_position", global_transform.origin)
		
		if is_network_master():
	
			rpc_unreliable("_SetDirection", direction)
		if Input.is_action_just_pressed("kill"):
			kill()
		if Input.is_action_just_pressed("report"):
			report()
		if Input.is_action_just_pressed("use"):
			if CurrentMission != null:
				CurrentMission.Quest()
	else :
		direction = Vector2(0, 0)
		if is_network_master():
			rpc_unreliable("_SetDirection", direction)
		
remote func share_name(name):
	$PlayerName.text = name
	player_name = name

func SetRunningSprite(direction):
	if (direction == Vector2(0, 0)):
		AnimTree.idle()
	else :
		if (direction.x != 0):
			if (direction.x > 0):
				if (wasLeft == false):
					if (PlayerSprite.scale.x < 0):
						wasLeft = true
					pass
				else :
					wasLeft = false
					AnimTree.Rotate()
			else :
				if (wasLeft == true):
					if (PlayerSprite.scale.x > 0):
						wasLeft = false
				else :
					wasLeft = true
					AnimTree.Rotate()
		AnimTree.run()
	
remote func StartGame():
	print("HEY")


func _on_network_peer_connected(id):
	if is_network_master():
		rpc("_set_position", global_transform.origin)
		rpc("share_name", Globals.player_name)
		rpc("share_color", Globals.player_color)





func _on_AreaKill_body_entered(body):
	if is_network_master():
		ActualizarListaJugadoresEnRadio(body, true)
		print(body)
	


func _on_AreaKill_body_exited(body):
	if is_network_master():
		ActualizarListaJugadoresEnRadio(body, false)
	

func ActualizarListaJugadoresEnRadio(body, add):
	if is_network_master():
		if (body != self):
			if body.has_method("ActualizarListaJugadoresEnRadio"):
				if (Globals.youreimpostor == true):
					if (add == true and body.IsDed == false):
						JugadoresEnRadio.append(body)
						get_parent().get_parent().get_parent().get_parent().get_node("HUDplayer").HideKill(false)
					elif (add == false and body.IsDed == false):
						JugadoresEnRadio.remove(JugadoresEnRadio.find(body, 0))
					if JugadoresEnRadio.empty():
						get_parent().get_parent().get_parent().get_parent().get_node("HUDplayer").HideKill(true)
				if (add == true and body.IsDed == true):
					JugadoresMuertos.append(body)
					get_parent().get_parent().get_parent().get_parent().get_node("HUDplayer").HideReporte(false)
				elif (add == false and body.IsDed == true):
					JugadoresMuertos.remove(JugadoresMuertos.find(body, 0))
					if (JugadoresMuertos.size() <= 0):
						get_parent().get_parent().get_parent().get_parent().get_node("HUDplayer").HideReporte(true)
			else :
				if body.has_method("Quest"):
					if add == true:
						get_parent().get_parent().get_parent().get_parent().get_node("HUDplayer").HideUse(false)
						CurrentMission = body
					else :
						get_parent().get_parent().get_parent().get_parent().get_node("HUDplayer").HideUse(true)
						CurrentMission = null
					
				

func report():
	if JugadoresMuertos != []:
		rpc("ReportAlarm", JugadoresMuertos[0].get_node("Sprite").self_modulate)

remotesync func ReportAlarm(ColorMuerto):
	HUDreport = preload("res://Modules/HUDreport.tscn").instance()
	get_tree().get_root().add_child(HUDreport)
	HUDreport.SetColor(ColorMuerto)
	Globals.HUDplayer.get_node("BotonReporte").visible = false
	Globals.HUDplayer.get_node("BotonUso").visible = false
	Globals.CanMove = false

func kill():

	if (Globals.youreimpostor == true and Globals.KillCooldown <= 1):
		var PlayerToKill = null
		var MaxDistance = 300
		for a in JugadoresEnRadio:
			if (MaxDistance > self.global_position.distance_to(a.global_position)):
				PlayerToKill = a
				MaxDistance = self.global_position.distance_to(a.global_position)
		if (PlayerToKill != null and PlayerToKill.IsDed == false):
			global_position = PlayerToKill.global_position
			rpc("_set_position", global_transform.origin)
			Globals.KillCooldown = 30
			var deadplayer = load("res://deadplayer.tscn").instance()
			deadplayer.position = PlayerToKill.position + Vector2(0, 1)
			deadplayer.setcolor(PlayerToKill.get_node("Sprite").self_modulate)
			var directionToFace = - 1
			if ($Sprite.scale.x > 0.1):
				directionToFace = 1
			deadplayer.scale.x = deadplayer.scale.x * directionToFace

			rpc("SpawnDeadPlayer", PlayerToKill.name, deadplayer.position, directionToFace)
			$Camera.HacerZoom(0.21, 0.95)
			var amountOfPeopleAlive = 0
			for b in get_parent().get_children():
				if self.has_node("PlayerName") == true:
					if (b.IsDed == false):
						amountOfPeopleAlive = amountOfPeopleAlive + 1
						print("People alive:" + str(amountOfPeopleAlive))
				else :
					pass
			if (amountOfPeopleAlive <= 2):
				print("EVERYONE'S FUCKING DEAD")
				rpc("ImpostorWin")

remotesync func ImpostorWin():
	Globals.DisplayWinScreen(true)
			
remotesync func SpawnDeadPlayer(KilledPlayerName, Pos, directionToFace):
	if not get_tree().is_network_server():
		var playerWhoDed = FindPlayer(KilledPlayerName)
		var deadplayer = load("res://deadplayer.tscn").instance()
		get_parent().add_child(deadplayer)
		deadplayer.position = Pos
		get_node("KillSoundEffect").play()
		deadplayer.setcolor(playerWhoDed.get_node("Sprite").self_modulate)
		deadplayer.scale.x = deadplayer.scale.x * directionToFace
		if KilledPlayerName != str(get_tree().get_network_unique_id()):
			playerWhoDed.visible = false
		else :
			Globals.IsAlive = false
		playerWhoDed.get_node("Sprite/AnimationTree").set("parameters/conditions/IsDed", true)
		playerWhoDed.IsDed = true
		for w in get_node("AreaKill").get_overlapping_bodies():
			if w.has_method("ActualizarListaJugadoresEnRadio"):
				w.ActualizarListaJugadoresEnRadio(playerWhoDed, false)
				w.ActualizarListaJugadoresEnRadio(playerWhoDed, true)

func FindPlayer(player):
	print("the player ID is " + player)
	return get_parent().get_node(player)

func FootStep():



	var audio_stream_player = AudioStreamPlayer2D.new()

	self.add_child(audio_stream_player)
	audio_stream_player.bus = "Effects"
	audio_stream_player.stream = FootStepSoundEffect
	audio_stream_player.volume_db = 20
	audio_stream_player.pitch_scale = rand_range(0.8, 1.3)
	audio_stream_player.max_distance = 200
	audio_stream_player.play()
	audio_stream_player.connect("finished", audio_stream_player, "queue_free")
