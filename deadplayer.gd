extends Node2D
var IsDed = true


func _ready():
	$Sprite / AnimationPlayer.play("DeadAnimation")

func setcolor(colorToSet):
	$Sprite.self_modulate = colorToSet
