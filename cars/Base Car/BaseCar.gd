extends VehicleBody3D


@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
@export var max_speed = 200
@export var blur_amount=0.012
@export var force_curve : Curve

enum modes{
	keyboad,
	stearing 
}
var stear_mode = modes.keyboad
var steer_target = 0

@export var smoke_emiters : Array[GPUParticles3D]
func _ready():
	if OS.get_name() == "Android":
		stear_mode = modes.stearing
		
func _physics_process(delta):
#	var speed=-$wheal3.get_rpm()*0.377*$wheal3.wheel_radius
	var speed=linear_velocity.length()*3.6
	traction(speed)
	$Hud/speed.text=str(round(speed))
	
	$"vfx/motion blur".material.set("shader_parameter/blur_power",clamp(remap(speed,90,180,0,blur_amount),0,0.2))
	$"vfx/Speed lines".material.set("shader_parameter/mask_edge",remap(speed,40,180,1,0.4))
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
		for i in smoke_emiters:
			i.emitting = true
	else:
		$wheal2.wheel_friction_slip=3
		$wheal3.wheel_friction_slip=3
		brake=0
		for i in smoke_emiters:
			i.emitting = false
	if stear_mode:
		steering = $Hud/Control/stearing.steer_amount
	else:
		steering = move_toward(steering, steer_target, STEER_SPEED * delta)



func traction(speed):
	if speed>0:
		apply_central_force(Vector3.DOWN*speed)
