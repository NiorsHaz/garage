extends CharacterBody2D

var move_speed : float = 150
var cars_in_range: Array[Car] = []
@onready var repair_ui: Control = $Repair_UI

var cars: Array[Car] = []
var active_car: Car = null

#signal interact_car(car: Car)
signal repair_part(part: String, car: Car)


func _ready() -> void:
	repair_ui.connect("selected_part", _on_repair_part_selected)

func _process(delta: float) -> void:
	var direction_y = Input.get_axis("Up", "Down")
	if Input.is_action_just_released("Up") || Input.is_action_just_released("Down"):
		direction_y = 0

	if direction_y != 0:
		global_position.y += (move_speed * direction_y) * delta
		

	var direction_x = Input.get_axis("Left", "Right")
	if direction_x == -1 :
		$Sprite2D.flip_h = true
	elif direction_x == 1:
		$Sprite2D.flip_h = false
	if Input.is_action_just_released("Left") || Input.is_action_just_released("Right"):
		direction_x = 0
	
	if  direction_x != 0:
		global_position.x += (move_speed * direction_x) * delta

	if direction_x || direction_y && !$AnimationPlayer.is_playing() :
		$AnimationPlayer.play("walk")
	elif direction_x == 0 && direction_y == 0:
		$AnimationPlayer.stop()

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
			#emit_signal("interact_car", car)
			active_car = car
			if active_car.is_connected("repair_progressed", _on_car_repair_progress):
				active_car.disconnect("repair_progressed", _on_car_repair_progress)
				active_car.disconnect("repair_finished", _on_car_repair_finished)
				
			repair_ui.open_for_car(active_car)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Car:
		print("Car : "+body.data._get_matriculation())
		cars_in_range.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Car:
		cars_in_range.erase(body)
		
func _on_player_interact_car(car: Car) -> void:
	# If switching cars
	if active_car and active_car != car:
		if active_car.is_connected("repair_progressed", _on_car_repair_progress):
			active_car.disconnect("repair_progressed", _on_car_repair_progress)
			active_car.disconnect("repair_finished", _on_car_repair_finished)

		#active_car.cancel_repair()

	active_car = car
	repair_ui.open_for_car(car)

func _on_repair_part_selected(part: String, car: Car) -> void:
	emit_signal("repair_part", part, car)
	if not car.is_connected("repair_progressed", _on_car_repair_progress):
		car.connect("repair_progressed", _on_car_repair_progress)
		car.connect("repair_finished", _on_car_repair_finished)

	car.start_repair(part)

func _on_car_repair_progress(part: String, progress: float) -> void:
	repair_ui.update_part_progress(part, progress)

func _on_car_repair_finished(part: String) -> void:
	repair_ui.finish_part(part)
