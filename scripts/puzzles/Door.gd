extends AnimatedSprite

export var close_delay : float

var _signal_count : int = 0 # how many buttons are keeping door open?

func _ready():
	$CloseDelay.wait_time = close_delay

func open():
	_signal_count += 1
	if _signal_count == 1 and $OpenCollisionDelay.is_stopped():
		if $CloseDelay.is_stopped():
			stop()
			frame = 0
			play("open")
			$CloseCollisionDelay.stop()
			$OpenCollisionDelay.start()
			$SlideAudio.stop()
			$SlideAudio.play()
		else:
			$CloseDelay.stop()

func start_closing():
	_signal_count -= 1
	_signal_count = max(0, _signal_count)
	if $CloseDelay.is_stopped() and _signal_count == 0:
		$CloseCollisionDelay.stop()
		$CloseDelay.start()

func close():
	$SlideAudio.stop()
	$SlideAudio.play()
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
