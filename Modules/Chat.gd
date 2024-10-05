extends CanvasLayer

var max_messages = 7

func _input(event):
	if OS.get_name() != "Android":
		if Input.is_action_just_pressed("ui_accept"):
			sendMessage()
		
func sendMessage():
		if $Message / TypedMessage.text != "":
			rpc("message", Globals.player_name, $Message / TypedMessage.text, Globals.IsAlive)

			$Message / TypedMessage.clear()


		

remotesync func message(player_name, data, IsNotGhost):
	if Globals.IsAlive == IsNotGhost or Globals.IsAlive == false:
		if $ChatBox.visible == false:
			$dot.visible = true
		var display_message = RichTextLabel.new()
		display_message.rect_min_size = Vector2(1000, 30)
		display_message.bbcode_enabled = true
		display_message.add_font_override("normal_font", load("res://Font/UbuntuMonoFont.tres"))
		$PopSound.play()
		
		$ChatBox.add_child(display_message)
	
		if IsNotGhost == true:
			display_message.bbcode_text = player_name + ": " + data
		else :
			display_message.bbcode_text = "[wave](dead) " + player_name + ": " + data
		if $ChatBox.get_child_count() > max_messages:
				$ChatBox.get_child(0).queue_free()


func _on_Button_button_down():
	sendMessage()


func _on_ToggleVisibility_pressed():
	$dot.visible = false
	$ChatBox.visible = not $ChatBox.visible
	$Message.visible = not $Message.visible
	$BGCol.visible = not $BGCol.visible



