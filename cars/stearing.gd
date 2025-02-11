extends Sprite2D

@export var steer_limit: float = 720
@export var rotation_smoothness: float = 4.0
var steer_amount = 0.0
var turning = false
var start_vec = Vector2.ZERO
var touch_indices = {}

func _input(event):
	if event is InputEventScreenTouch:
		var touch = event as InputEventScreenTouch
		if touch.pressed:
			if is_in_circle(touch.position, 350):
				touch_indices[touch.index] = "steering_wheel"
				start_vec = touch.position - global_position
				turning = true
		else:
			if touch.index in touch_indices:
				if touch_indices[touch.index] == "steering_wheel":
					turning = false
				touch_indices.erase(touch.index)
	elif event is InputEventScreenDrag:
		if event.index in touch_indices and touch_indices[event.index] == "steering_wheel":
			drag(event)

func _process(delta: float) -> void:
	if not turning:
		rotation = lerp(rotation, 0.0, rotation_smoothness * delta)
	steer_amount = -(rotation / deg_to_rad(steer_limit))

func drag(event):
	var current_vec = event.position - global_position
	var angle_difference = start_vec.angle_to(current_vec)
	rotation = clamp(rotation + angle_difference, deg_to_rad(-steer_limit), deg_to_rad(steer_limit))
	start_vec = current_vec

func is_in_circle(pos: Vector2, radius: float) -> bool:
	return pos.distance_to(global_position) < radius
