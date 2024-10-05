extends Camera2D

onready var t = get_node("CamTimer")

func _ready():
	$CamAnim.play("IdleShake")

func HacerZoom(sec, amount):
	t.set_wait_time(0.31)
	t.start()
	$CamAnim.play("Kill")
	yield (t, "timeout")
	restoreNormalCamera()
	
func restoreNormalCamera():
	$CamAnim.play("IdleShake")
