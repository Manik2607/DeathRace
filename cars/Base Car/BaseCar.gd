extends VehicleBody3D


@export var STEER_SPEED = 1.5
@export var STEER_LIMIT = 0.6
@export var STEER_FACTOR = 0.8
@export var max_speed = 200
@export var blur_amount=0.012
@export var downward_force = 1.5
@export var boost_force = 500
@export var force_curve : Curve

@export var sync_pos:Vector3 = Vector3.ZERO
@export var sync_rot:Vector3 = Vector3.ZERO


enum modes{
	keyboad,
	stearing
}
var stear_mode = modes.keyboad
var steer_target = 0

@export var smoke_emiters : Array[GPUParticles3D]


# Peer id.
@export var peer_id : int :
	set(value):
		peer_id = value
		name = str(peer_id)
		$Label3D.text = str(peer_id)
		set_multiplayer_authority(peer_id)

func _ready():
	if OS.get_name() == "Android":
		stear_mode = modes.stearing
		
	var is_local = is_multiplayer_authority()
	$look/Camera3D.current = is_local
	$AudioListener3D.current = is_local
	set_process_input(is_local)
	set_physics_process(is_local)
	#set_process(is_local)
	$vfx.visible = is_local
	$look/Camera3D.set_physics_process(is_local)

		

func _physics_process(delta):
#	var speed=-$wheal3.get_rpm()*0.377*$wheal3.wheel_radius
	var speed=linear_velocity.length()*3.6
	traction(speed)
	$Hud/speed.text=str(round(speed))
	
	$"vfx/motion blur".material.set("shader_parameter/blur_power",clamp(remap(speed,100,max_speed,0,blur_amount),0,0.2))
	$"vfx/Speed lines".material.set("shader_parameter/mask_edge",remap(speed,50,max_speed,1,0.35))
	if Input.is_action_pressed("r"):
		get_tree().reload_current_scene()
		
	var fwd_map = transform.basis.x.x
		
	var speed_scale = remap(speed,0,max_speed,0,1)
	steer_target = Input.get_action_strength("left") - Input.get_action_strength("right")
	steer_target *= STEER_LIMIT * (1-speed_scale * STEER_FACTOR)
	if Input.is_action_pressed("backward"):
		engine_force = force_curve.sample(speed_scale)
	else:
		engine_force = 0
		
	if Input.is_action_pressed("forward"):
		if fwd_map>=-2:
			engine_force = -force_curve.sample(speed_scale)
		else:
			brake=0

	if Input.is_action_pressed("boost"):
		var dir = -transform.basis.z
		apply_central_force(dir*boost_force)

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
	sync_pos = global_position
	sync_rot = global_rotation

func _process(delta):
	handle_sound()
	sync_pos_rot()



func traction(speed):
	if speed>0:
		apply_central_force(Vector3.DOWN*speed*downward_force)
		
func handle_sound():
	var speed = linear_velocity.length()  # Get the speed in meters per second
	var max_engine_speed = 100.0  # Adjust based on your game's top engine speed
	var engine_speed = clamp(speed / max_engine_speed, 0.0, 1.0)
	
	var pitch_base = 1.0  # Base pitch for idle sound
	var pitch_max = 2.5  # Maximum pitch for acceleration sound
	var pitch = lerpf(pitch_base, pitch_max, engine_speed)
	pitch += randf_range(-0.02, 0.02)  # Slight fluctuation for realism
	
	# Smoothly interpolate pitch to avoid sudden changes
	$AudioStreamPlayer3D_Accel.pitch_scale = lerp($AudioStreamPlayer3D_Accel.pitch_scale, pitch, 0.1)
	$AudioStreamPlayer3D_Idle.pitch_scale = lerp($AudioStreamPlayer3D_Idle.pitch_scale, pitch_base, 0.1)
	
	if Input.is_action_pressed("forward"):  # If the vehicle is moving, play the acceleration sound
		if !$AudioStreamPlayer3D_Accel.playing:
			$AudioStreamPlayer3D_Accel.play()
		if $AudioStreamPlayer3D_Idle.playing:
			$AudioStreamPlayer3D_Idle.stop()
	else:  # If the vehicle is idle, play the idle sound
		if !$AudioStreamPlayer3D_Idle.playing:
			$AudioStreamPlayer3D_Idle.play()
		if $AudioStreamPlayer3D_Accel.playing:
			$AudioStreamPlayer3D_Accel.stop()


func win():
	print($Label3D.text+ " player win")
	


func _on_timer_timeout():
	_ready()

@rpc("any_peer","call_local","reliable")
func set_pos(pos:Vector3):
	$MultiplayerSynchronizer.process_mode = Node.PROCESS_MODE_DISABLED
	global_position = pos
	rotation = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	engine_force = 0
	$MultiplayerSynchronizer.process_mode = Node.PROCESS_MODE_INHERIT

func sync_pos_rot():
	if !is_multiplayer_authority():
		global_position = global_position.lerp(sync_pos, 0.3)
		global_rotation = global_rotation.lerp(sync_rot, 1)
