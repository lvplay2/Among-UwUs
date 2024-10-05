extends CanvasLayer








func _ready():
	set_process_input(true)
	pass















func _process(delta):
	if Input.is_action_just_released("touch"):
		print("Left mouse button released.")
		Input.action_release("move_up")
		Input.action_release("move_right")


func _on_ButtonUP_pressed():
	Input.action_press("move_up", 1)
	Input.action_release("move_right")



func _on_ButtonDOWN_pressed():
	Input.action_press("move_up", - 1)
	Input.action_release("move_right")



func _on_ButtonRIGHT_pressed():
	Input.action_press("move_right", 1)
	Input.action_release("move_up")

func _on_ButtonLEFT_pressed():
	Input.action_press("move_right", - 1)
	Input.action_release("move_up")


func _on_ButtonLEFTUP_pressed():
	Input.action_release("move_up")
	Input.action_release("move_right")
	Input.action_press("move_right", - 0.5)
	Input.action_press("move_up", 0.5)


func _on_ButtonRIGHTUP_pressed():
	Input.action_release("move_up")
	Input.action_release("move_right")
	Input.action_press("move_right", 0.5)
	Input.action_press("move_up", 0.5)


func _on_ButtonRIGHTDOWN_pressed():
	Input.action_release("move_up")
	Input.action_release("move_right")
	Input.action_press("move_right", 0.5)
	Input.action_press("move_up", - 0.5)


func _on_ButtonLEFTDOWN_pressed():
	Input.action_release("move_up")
	Input.action_release("move_right")
	Input.action_press("move_right", - 0.5)
	Input.action_press("move_up", - 0.5)


func _on_ButtonCentral_pressed():
	Input.action_release("move_up")
	Input.action_release("move_right")
