extends AnimationTree


var playback: AnimationNodeStateMachinePlayback
var Running = false
var playerdir = 3
var tempdir = 0



func _ready():
	playback = get("parameters/playback")
	playback.start("Idle")
	active = true
	
func Rotate():
	set("parameters/conditions/Rotating", true)
	set("parameters/conditions/NotRotating", false)
	
	set("parameters/conditions/RotatingIdle", not Running and true)
	set("parameters/conditions/NotRotatingIdle", not Running and false)
	
	SetTemporalDir()
	
func SetTemporalDir():
	tempdir = playerdir
	
func RotateSprite():
	if (tempdir != 0):
	
		if (tempdir > 0):

			get_node("..").scale.x = 0.444








		else :
			get_node("..").scale.x = - 0.444










	else :
		get_node("../..").wasLeft = not get_node("../..").wasLeft
	
func UnRotate():
	set("parameters/conditions/Rotating", false)
	set("parameters/conditions/NotRotating", true)
	
	set("parameters/conditions/RotatingIdle", not Running and false)
	set("parameters/conditions/NotRotatingIdle", not Running and true)
	
func idle():
	if (Running == false):
		pass
	else :
		Running = false

		set("parameters/conditions/Running", Running)
		set("parameters/conditions/NotRunning", not Running)
		

func run():
	if (Running == true):
		pass
	else :
		Running = true
		set("parameters/conditions/Running", Running)
		set("parameters/conditions/NotRunning", not Running)






