extends Node2D

@onready var car_scene: PackedScene = preload("res://Scenes/Entity/Car.tscn")

var cars: Array[Car] = []

func _ready() -> void:
	var car: Car = car_scene.instantiate()

	car.setup(
		"12354TBA",
		["Frein",
		"Vidange"]
	)
	car.name = car.data._get_matriculation()
	add_child(car)
	cars.append(car)

	# Getting the info per parts
	print(car.name + " Total repair time: ", car.get_repair_time(car.repair_point[0]))
	# Getting the info of all parts combined
	print(car.name + " Total repair time: ", car.get_total_repair_parts())
