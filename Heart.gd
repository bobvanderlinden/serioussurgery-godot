extends Node2D


func _ready():
	pass # Replace with function body.

func _process(delta):
	var time = OS.get_ticks_msec() / 1000.0
	$Transformer.scale = Vector2(
		1 + cos(time * PI) * 0.1,
		1 + sin(time * PI) * 0.1
	)

func on_hold():
	pass
#	mode = RigidBody2D.MODE_STATIC
#	position = Vector2.ZERO;
#	rotation = 0

func on_release():
	pass
#	mode = RigidBody2D.MODE_RIGID
