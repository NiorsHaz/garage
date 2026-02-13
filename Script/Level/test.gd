extends Control

@onready var car_scene: PackedScene = preload("res://Scenes/Entity/Car.tscn")
@onready var repair_ui: Control = $Repair_UI
@onready var player: CharacterBody2D = $Player
@onready var place1: Marker2D = $Marker2D
@onready var place2: Marker2D = $Marker2D2

var cars: Array[Car] = []
var active_car: Car = null


func _ready() -> void:
	#repair_ui.connect("selected_part", _on_repair_part_selected)
	player.repair_part.connect(_on_repair_part_selected)

	var car: Car = car_scene.instantiate()
	var car1: Car = car_scene.instantiate()

	car.setup("12354TBA", ["Frein", "Vidange"])
	car1.setup("456123TBA", ["Vidange", "Frein"])

	car.name = car.data._get_matriculation()
	car1.name = car1.data._get_matriculation()
	
	car.global_position = place1.global_position
	car1.global_position = place2.global_position

	add_child(car)
	add_child(car1)

	cars.append(car)
	cars.append(car1)
#
func _on_repair_part_selected(part: String, car: Car) -> void:
	car.start_repair(part)
