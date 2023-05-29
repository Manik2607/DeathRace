extends VehicleBody3D


@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
var steer_target = 0
@export var engine_force_value = 40
@export var Blur_Amount=0.02

var stear_mode=1
func _physics_process(delta):
	var speed=-$wheal3.get_rpm()*0.377*$wheal3.wheel_radius
	traction(speed)
#	$Hud/speed.text=str(round(speed))
	
#	$"motion blur".material.set("shader_parameter/blur_power",speed*Blur_Amount*delta)
#	$"Speed lines".material.set("shader_parameter/mask_edge",remap(speed,30,200,1,0.4))
	if Input.is_action_pressed("r"):
		get_tree().reload_current_scene()
	var fwd_mps = transform.basis.x.x
	steer_target = Input.get_action_strength("a") - Input.get_action_strength("d")
	steer_target *= STEER_LIMIT
	if Input.is_action_pressed("s"):
	# Increase engine force at low speeds to make the initial acceleration faster.

		if speed < 20 and speed != 0:
			engine_force = clamp(engine_force_value , 0, 300)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0
	if Input.is_action_pressed("w"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			if speed < 30 and speed != 0:
				engine_force = -clamp(engine_force_value , 0, 300)
			else:
				engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
		
	if Input.is_action_pressed("break"):
		brake=3
		$wheal2.wheel_friction_slip=0.8
		$wheal3.wheel_friction_slip=0.8
	else:
		$wheal2.wheel_friction_slip=3
		$wheal3.wheel_friction_slip=3
	if stear_mode:
		steering = $Hud/Control/stearing.steer_amount
	else:
		steering = move_toward(steering, steer_target, STEER_SPEED * delta)





func traction(speed):
	if speed>0:
		apply_central_force(Vector3.DOWN*speed)








func _on_h_slider_value_changed(value):
	STEER_SPEED=value


func _on_h_slider_value_changed_speed(value):
	engine_force_value=value


func _on_blur_value_changed(value):
	Blur_Amount=value

