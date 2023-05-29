extends Sprite2D

@export var stear_limit:float = 540
var steer_amount=0.0
var turning=false
var rot:=0.0
var start_vec=Vector2.ZERO

func _input(event):
	if event is InputEventScreenDrag:
		drag(event)
	if event is InputEventScreenTouch:
		var touch = event as InputEventScreenTouch
		if touch.pressed:
			rot = Vector2(event.position-global_position).angle_to(start_vec)
			start_vec=event.position - global_position
		else:
			turning=false

func _process(delta: float) -> void:
	if not turning:
		rotation=lerp(rotation,0.0,4*delta)
	steer_amount = -(rotation / deg_to_rad(stear_limit))


func drag(event):
	turning=true
	rot = Vector2(event.position-global_position).angle_to(start_vec)
	start_vec=event.position - global_position
	rotation=clamp(rotation-rot,deg_to_rad(-stear_limit),deg_to_rad(stear_limit))
	
	
	





