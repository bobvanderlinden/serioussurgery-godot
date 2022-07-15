extends RigidBody2D

var jumpSamples = [
	preload("res://jump/jump01.wav"),
	preload("res://jump/jump02.wav"),
	preload("res://jump/jump03.wav"),
	preload("res://jump/jump04.wav")
]

var heartSamples = [
	preload("res://heart/heart01.wav"),
	preload("res://heart/heart02.wav"),
	preload("res://heart/heart03.wav"),
	preload("res://heart/heart04.wav")
]

var ouchSamples = [
	preload("res://ouch/ouch01.wav"),
	preload("res://ouch/ouch02.wav"),
	preload("res://ouch/ouch03.wav"),
	preload("res://ouch/ouch04.wav"),
	preload("res://ouch/ouch05.wav")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement = (1 if Input.is_action_pressed("right") else 0) - (1 if Input.is_action_pressed("left") else 0)
	var desiredAngularVelcity = movement * delta * 1500
	self.angular_velocity = self.angular_velocity * 0.9 + desiredAngularVelcity * 0.1;
	
	# self.linear_velocity +=  Vector2.RIGHT * movement * 1
	
	var isOnGround = false
	var state = Physics2DServer.body_get_direct_state(self.get_rid())
	var contact_count = state.get_contact_count()
	for contact_idx in range(0, contact_count):
		var normal = state.get_contact_local_normal(contact_idx)
		if normal.y < 0:
			isOnGround = true
	
	if Input.is_action_just_pressed("jump") && isOnGround:
		self.linear_velocity += Vector2.UP * 50
		play_sample(jumpSamples)

func play_sample(samples):
	$Audio.stream = samples[randi() % samples.size()]
	$Audio.play()

func get_heart():
	return $HeartContainer.get_child(0)

func hold_heart(heart):
	$HeartTimer.stop()
	$HeartTimer.start()
	$HeartContainer.add_child(heart)
	heart.on_hold()

func release_heart():
	$HeartContainer.remove_child(self.get_heart())

func _on_Player_body_entered(body):
	if body.is_in_group("Heart"):
		if body != get_heart():
			hold_heart(body)
	if body.is_in_group("Patient"):
		if !$HeartTimer.is_stopped():
			pass
		if body.get_heart():
			var heart = body.get_heart()
			body.release_heart()
			hold_heart(heart)
			play_sample(heartSamples)
		elif self.get_heart():
			var heart = self.get_heart()
			self.release_heart()
			body.hold_heart(heart)
			play_sample(heartSamples)
	if body.is_in_group("Person"):
		play_sample(ouchSamples)
