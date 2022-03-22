extends AnimatedSprite

func open():
	if $OpenCollisionDelay.is_stopped():
		if $CloseDelay.is_stopped():
			print("opening")
			stop()
			frame = 0
			play("open")
			$CloseCollisionDelay.stop()
			$OpenCollisionDelay.start()
		else:
			$CloseDelay.stop()

func start_closing():
	if $CloseDelay.is_stopped():
		print("starting to close")
		$CloseCollisionDelay.stop()
		$CloseDelay.start()

func close():
	stop()
	frame = 0
	play("close")
	$OpenCollisionDelay.stop()
	$CloseDelay.stop()
	$CloseCollisionDelay.start()

func enable_collision():
	$StaticBody2D.set_collision_layer_bit(0, true)

func disable_collision():
	$StaticBody2D.set_collision_layer_bit(0, false)
