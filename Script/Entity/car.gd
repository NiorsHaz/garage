class_name Car
extends Node2D

var data: CarData
var repair_point: Array = []

@export var base_time_per_part: float = 2.0


# Proper initialization method
func setup(matricule: String, points: Array) -> void:
	data = CarData.new()
	data.matriculation = matricule
	repair_point = points


# Get the repair time per part
func get_repair_time(part: String) -> float:
	if not data or not data.reparation_level.has(part):
		return base_time_per_part
	return base_time_per_part * data.reparation_level[part]


# Progress bar speed
func get_progress_speed(part: String, base_speed: float) -> float:
	if not data or not data.reparation_level.has(part):
		return base_speed
	return base_speed / data.reparation_level[part]

func get_total_repair_parts() -> float:
	if not repair_point:
		return 0.0
	
	var total_time := 0.0
	for part in repair_point:
		if part in data.reparation_level.keys():
			total_time += base_time_per_part * data.reparation_level[part]
			
	return total_time

# Total repair time
func get_total_repair_time() -> float:
	if not data:
		return 0.0

	var total_time := 0.0
	for part in data.reparation_level.keys():
		print(part)
		total_time += base_time_per_part * data.reparation_level[part]

	return total_time
