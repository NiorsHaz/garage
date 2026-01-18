class_name Car
extends StaticBody2D

# =========================
# DATA
# =========================

var data: CarData
var repair_points: Array[String] = []

@export var base_time_per_part: float = 2.0

# Repair state
var current_part: String = ""
var repair_progress: float = 0.0
var is_repairing: bool = false

# =========================
# SIGNALS
# =========================

signal repair_started(part: String)
signal repair_progressed(part: String, progress: float)
signal repair_finished(part: String)

# =========================
# INITIALIZATION
# =========================

func setup(matricule: String, points: Array[String]) -> void:
	data = CarData.new()
	data.matriculation = matricule
	repair_points = points


# =========================
# VALIDATION / HELPERS
# =========================

func has_part(part: String) -> bool:
	return data != null and data.reparation_level.has(part)


# =========================
# PER-PART CALCULATIONS
# =========================

func get_repair_time(part: String) -> float:
	if not has_part(part):
		return base_time_per_part
	return base_time_per_part * data.reparation_level[part]


func get_progress_speed(part: String) -> float:
	if not has_part(part):
		return 1.0
	return 1.0 / data.reparation_level[part]

# =========================
# REPAIR CONTROL
# =========================

func start_repair(part: String) -> void:
	if is_repairing:
		return
	if not repair_points.has(part):
		return

	current_part = part
	repair_progress = 0.0
	is_repairing = true
	emit_signal("repair_started", part)


func cancel_repair() -> void:
	is_repairing = false
	current_part = ""
	repair_progress = 0.0

# =========================
# PROCESS LOOP
# =========================

func _process(delta: float) -> void:
	if not is_repairing:
		return

	repair_progress += get_progress_speed(current_part) * delta
	repair_progress = clamp(repair_progress, 0.0, 1.0)

	emit_signal("repair_progressed", current_part, repair_progress)

	if repair_progress >= 1.0:
		_finish_repair()


func _finish_repair() -> void:
	is_repairing = false
	repair_points.erase(current_part)

	emit_signal("repair_finished", current_part)

	current_part = ""
	repair_progress = 0.0

# =========================
# AGGREGATE CALCULATIONS
# =========================

# Total time for ONLY the parts that need repair
func get_total_repair_parts_time() -> float:
	if data == null or repair_points.is_empty():
		return 0.0

	var total_time := 0.0
	for part in repair_points:
		if has_part(part):
			total_time += get_repair_time(part)

	return total_time


# Total time for ALL repairable parts
func get_total_repair_time() -> float:
	if data == null:
		return 0.0

	var total_time := 0.0
	for part in data.reparation_level.keys():
		total_time += get_repair_time(part)

	return total_time
