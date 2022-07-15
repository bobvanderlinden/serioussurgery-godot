extends RigidBody2D

var heartScene = preload("res://Heart.tscn")
export var initWithHeart = false

func _ready():
	if initWithHeart:
		hold_heart(heartScene.instance())

func hold_heart(heart):
	if heart.get_parent():
		heart.get_parent().remove_child(heart)
	$HeartContainer.add_child(heart)
	heart.on_hold()

func release_heart():
	$HeartContainer.remove_child(get_heart())

func get_heart():
	return $HeartContainer.get_child(0)
