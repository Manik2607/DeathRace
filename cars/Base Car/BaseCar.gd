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
	# Set local camera.
	$look/Camera3D.current = peer_id == multiplayer.get_unique_id()
	# Set process functions for current player.
	$AudioListener3D.current = peer_id == multiplayer.get_unique_id()
	var is_local = is_multiplayer_authority()
	set_process_input(is_local)
	set_physics_process(is_local)
	set_process(is_local)
	$vfx.visible = is_local
	$look/Camera3D.set_physics_process(is_local)
		
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
		handle_sound()
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
		
		
		
		
func handle_sound():
	if !$AudioStreamPlayer3D.playing:
		$AudioStreamPlayer3D.play()  # Ensure the sound is playing

	var speed = linear_velocity.length()  # Get the speed in meters per second
	var pitch_base = 1.0  # Base pitch for idle or low speeds
	var pitch_max = 2.5  # Maximum pitch when at top speed
	var max_engine_speed = 100.0  # Adjust based on your game's top engine speed

	# Calculate pitch based on speed with a logarithmic curve for realism
	var engine_speed = clamp(speed / max_engine_speed, 0.0, 1.0)
	var pitch = lerpf(pitch_base, pitch_max, engine_speed)

	# Add a slight fluctuation for a more dynamic engine sound (optional)
	pitch += randf_range(-0.02, 0.02)

	# Smoothly interpolate pitch to avoid sudden changes
	$AudioStreamPlayer3D.pitch_scale = lerp($AudioStreamPlayer3D.pitch_scale, pitch, 0.1)
