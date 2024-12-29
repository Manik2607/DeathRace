extends Node3D

@export var cars: Array[VehicleBody3D] = []  # Array of cars
var index: int = 0  # Current index

# Label to display the selected car's information (must be set in the scene)
@onready var label: Label = $CanvasLayer/Control/Label

func _on_next_pressed():
	if cars.size() == 0:
		label.text = "No cars available"
		return

	index += 1
	if index >= cars.size():
		index = 0  # Wrap around to the first car

func _on_previous_pressed():
	if cars.size() == 0:
		label.text = "No cars available"
		return

	index -= 1
	if index < 0:
		index = cars.size() - 1  # Wrap around to the last car


# Function to identify a car (e.g., highlight it or print details)
func identify_car(car: VehicleWheel3D):
	# Example: Highlight the car
	car.modulate = Color(1, 1, 0)  # Change color to yellow
	print("Identifying car: ", car.name if car.has_meta("name") else "Unnamed")

func _on_select_pressed():
	if cars.size() == 0:
		label.text = "No cars available"
		return

	var selected_car = cars[index]
	identify_car(selected_car)
