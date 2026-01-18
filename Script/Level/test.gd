extends Control

@onready var car_scene: PackedScene = preload("res://Scenes/Entity/Car.tscn")
@onready var repair_ui: Control = $Repair_UI
@onready var player: CharacterBody2D = $Player

var cars: Array[Car] = []

func _ready() -> void:
	player.interact_car.connect(_on_player_interact_car)
	#repair_ui.get_list_repairs()
	var car: Car = car_scene.instantiate()
	var car1: Car = car_scene.instantiate()

	car.setup(
		"12354TBA",
		["Frein",
		"Vidange"]
	)
	car1.setup(
		"456123TBA",
		["Vidange",
		"Frein"]
	)
	
	car.name = car.data._get_matriculation()
	car1.name = car1.data._get_matriculation()
	add_child(car)
	add_child(car1)
	cars.append(car)

	# Getting the info per parts
	print(car1.name + " Total repair time: ", car1.get_repair_time(car1.repair_points[0]))
	# Getting the info of all parts combined
	print(car.name + " Total repair time: ", car.get_total_repair_parts_time())
	
	print(car.name + " Progress repair time: ", car.get_progress_speed(car.repair_points[1]))

func _on_player_interact_car(car: Car) -> void:
	print("Root received interaction with:", car.data.matriculation)
	repair_ui.open_for_car(car)
	#start_repair(car)

func start_repair(car: Car) -> void:
	var total_time = car.get_total_repair_parts_time()
	print("Repair will take:", total_time, "seconds")
