extends CanvasLayer





onready var tween = get_node("Tween")
var AreaToDestroy = null


func _ready():
	Globals.CanMove = false
	tween.interpolate_property($CenterContainer, "margin_top", 
		600, - 20, 0.6, 
		Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()





func SetAreaToDestroy(Area):
	AreaToDestroy = Area

func _on_DeleteButton_pressed():
	Globals.CanMove = true
	Globals.MissionCompleted()
	Globals.CurrentTask = null
	$CloseButton.visible = false
	AreaToDestroy.queue_free()
	$CenterContainer / defaultcubetaskBG / defaultcube.visible = false
	$DeleteButton.disabled = true
	yield (get_tree().create_timer(0.5), "timeout")

	$Label.visible = true
	tween.interpolate_property($Label, "rect_position", 
	Vector2(0, 665.788), Vector2(0, 286.5), 0.6, 
	Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
	yield (get_tree().create_timer(0.5), "timeout")
	tween.interpolate_property($CenterContainer, "margin_top", 
	- 20, 600, 0.6, 
	Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
	$DeleteButton.visible = false
	yield (get_tree().create_timer(0.5), "timeout")
	tween.interpolate_property($Label, "rect_position", 
	Vector2(0, 286.5), Vector2(0, 665.788), 0.6, 
	Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
	yield (get_tree().create_timer(0.2), "timeout")
	self.queue_free()
	


func _on_CloseButton_pressed():
	Globals.CanMove = true
	self.queue_free()
