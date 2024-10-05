extends LineEdit

var LockMovement

func _is_pos_in(checkpos: Vector2):
	
	var gr = get_global_rect()
	
	return checkpos.x >= gr.position.x and checkpos.y >= gr.position.y and checkpos.x < gr.end.x and checkpos.y < gr.end.y
func _input(event):
	if event is InputEventMouseButton and not _is_pos_in(event.position):
		release_focus()


func _on_TypedMessage_focus_entered():
	if Globals.CanMove == true:
		Globals.CanMove = false
		LockMovement = false
	else :
		LockMovement = true

func _on_TypedMessage_focus_exited():
	if LockMovement == false:
		Globals.CanMove = true
