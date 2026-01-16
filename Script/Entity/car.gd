class_name Car
extends Node2D

var data: CarData
var repair_point : Array
@export var base_time_per_part : float = 2.0

# When creating a car
func _init(matricule: String, points: Array) -> void:
	data._set_matriculation(matricule)
	repair_point = points

# Get the repair time per part to repair
func get_repair_time(part: String, base_time: float) -> float:
	if not data:
		return base_time
	return base_time * data.reparation_level[part]

# Get the value for the progress bar (visual purpose)
func get_progress_speed(part: String, base_speed: float) -> float:
	return base_speed / data.reparation_level[part]

# Get the time overall needed to repair the car
func get_total_repair_time() -> float:
	var total_time := 0.0

	for part in data.reparation_level.keys():
		total_time += base_time_per_part * data.reparation_level[part]

	return total_time
