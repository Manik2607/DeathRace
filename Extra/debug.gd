extends CanvasLayer



func _process(delta):
	$Fps.text = "FPS : " + str(round(Engine.get_frames_per_second()))
