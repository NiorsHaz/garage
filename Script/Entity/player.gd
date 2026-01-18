extends CharacterBody2D

var move_speed : float = 150
var cars_in_range: Array[Car] = []

signal interact_car(car: Car)

func _process(delta: float) -> void:
	var direction_y = Input.get_axis("Up", "Down")
	if Input.is_action_just_released("Up") || Input.is_action_just_released("Down"):
		direction_y = 0

	if direction_y != 0:
		global_position.y += (move_speed * direction_y) * delta

	var direction_x = Input.get_axis("Left", "Right")
	if Input.is_action_just_released("Left") || Input.is_action_just_released("Right"):
		direction_x = 0
	
	if  direction_x != 0:
		global_position.x += (move_speed * direction_x) * delta

	move_and_slide()

func get_closest_car() -> Car:
	if cars_in_range.is_empty():
		return null

	var closest: Car = null
	var min_dist := INF

	for car in cars_in_range:
		var d = global_position.distance_to(car.global_position)
		if d < min_dist:
			min_dist = d
			closest = car

	return closest

func _input(event):
	if event.is_action_pressed("Interact"):
		var car = get_closest_car()
		if car:
			emit_signal("interact_car", car)
			

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Car:
		print("Car : "+body.data._get_matriculation())
		cars_in_range.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Car:
		cars_in_range.erase(body)
