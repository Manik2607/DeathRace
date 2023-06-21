extends VehicleBody3D


@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var max_speed = 200
@export var Blur_Amount=0.02
@export var force_curve : Curve

var stear_mode = 1
func _physics_process(delta):
#	var speed=-$wheal3.get_rpm()*0.377*$wheal3.wheel_radius
	var speed=linear_velocity.length()*3.6
	traction(speed)
#	$Hud/speed.text=str(round(speed))
	
#	$"motion blur".material.set("shader_parameter/blur_power",speed*Blur_Amount*delta)
#	$"Speed lines".material.set("shader_parameter/mask_edge",remap(speed,30,200,1,0.4))
	if Input.is_action_pressed("r"):
		get_tree().reload_current_scene()
		
	var fwd_map = transform.basis.x.x
		
	steer_target = Input.get_action_strength("a") - Input.get_action_strength("d")
	steer_target *= STEER_LIMIT
	var speed_scale = remap(speed,0,max_speed,0,1)
	if Input.is_action_pressed("s"):
		engine_force = force_curve.sample(speed_scale)
	else:
		engine_force = 0
		
	if Input.is_action_pressed("w"):
		if fwd_map>=-2:
			engine_force = -force_curve.sample(speed_scale)
		else:
			brake=0

		
	if Input.is_action_pressed("break"):
		brake=3
		$wheal2.wheel_friction_slip=0.8
		$wheal3.wheel_friction_slip=0.8
	else:
		$wheal2.wheel_friction_slip=3
		$wheal3.wheel_friction_slip=3
		brake=0
	if stear_mode:
		steering = $Hud/Control/stearing.steer_amount
	else:
		steering = move_toward(steering, steer_target, STEER_SPEED * delta)



func traction(speed):
	if speed>0:
		apply_central_force(Vector3.DOWN*speed)










