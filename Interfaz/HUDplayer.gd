extends CanvasLayer

var timer = Timer.new()
var ImpostorCanKill = false

func HideReporte(shouldHide):
	if shouldHide == false:
		$BotonReporte.modulate = Color(1, 1, 1)
	else :
		$BotonReporte.modulate = Color(0.5, 0.5, 0.5, 0.5)
		
func HideUse(shouldHide):
	if shouldHide == false:
		$BotonUso.modulate = Color(1, 1, 1)
	else :
		$BotonUso.modulate = Color(0.5, 0.5, 0.5, 0.5)
		
func HideKill(shouldHide):
	ImpostorCanKill = not shouldHide
	if shouldHide == false:
		if Globals.KillCooldown <= 1:
			$BotonMatar.self_modulate = Color(1, 1, 1)
	else :
		$BotonMatar.self_modulate = Color(0.5, 0.5, 0.5, 0.5)
	
func _ready():
	if Globals.youreimpostor == true:
		$BotonMatar.visible = true

		timer.set_wait_time(1.0)
		
		timer.set_one_shot(false)
		timer.connect("timeout", self, "UpdateCounter")
		add_child(timer)

		timer.start()
	else :
		$BotonMatar.visible = false

func UpdateCounter():
	if Globals.KillCooldown <= 1:
		$BotonMatar / Delay.visible = false
		if ImpostorCanKill == true:
			$BotonMatar.self_modulate = Color(1, 1, 1)
	else :
		Globals.KillCooldown -= 1
		$BotonMatar / Delay.visible = true
		$BotonMatar.self_modulate = Color(0.5, 0.5, 0.5, 0.5)
		$BotonMatar / Delay.text = str(Globals.KillCooldown)

func UpdateMissionCounter():
	$GlobalLabel.text = "Global finished tasks: " + str(Globals.GlobalMissionsCompleted) + "/" + str(Globals.player_list.size() * 10 - 10)
	$YourLabel.text = "Your finished tasks: " + str(Globals.YourMissionsCompleted) + "/10"


func _on_BotonMatar_pressed():
	Input.action_press("kill")

func _on_BotonUso_pressed():
	Input.action_press("use")

func _on_BotonReporte_pressed():
	Input.action_press("report")


