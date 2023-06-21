extends Sprite2D

@export var stear_limit:float = 360
var steer_amount=0.0
var turning=false
var rot:=0.0
var start_vec=Vector2.ZERO
var index : int = -1
func _input(event):
	if event is InputEventScreenDrag :
		if index == event.index:
			drag(event)
		
			
	if event is InputEventScreenTouch :
		var touch = event as InputEventScreenTouch
		if touch.pressed:
			rot = Vector2(event.position-global_position).angle_to(start_vec)
			start_vec=event.position - global_position
			if is_in_circle(event.position,350) and index==-1:
				index = event.index
		else:
			if index==event.index:
				turning=false
				index = -1

func _process(delta: float) -> void:
	if not turning:
		rotation=lerp(rotation,0.0,4*delta)
	steer_amount = -(rotation / deg_to_rad(stear_limit))


func drag(event):
	turning=true
	rot = Vector2(event.position-global_position).angle_to(start_vec)
	start_vec=event.position - global_position
	rotation=clamp(rotation-rot,deg_to_rad(-stear_limit),deg_to_rad(stear_limit))
	
	
func is_in_circle(pos:Vector2,radi:float) -> bool:
#	print(pos,pos.distance_to(position))
	if pos.distance_to(global_position) < radi:
		return true
	else:
		return false
		





