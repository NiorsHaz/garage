extends Control

@onready var list: VBoxContainer = $List

@onready var repair_item_scene: PackedScene = preload("res://Scenes/UI/repair_part.tscn")

var current_car: Car

func open_for_car(car: Car) -> void:
	self.visible = true
	current_car = car
	clear_list()

	for part in car.repair_points:
		var item = repair_item_scene.instantiate()
		list.add_child(item)
		var time = car.get_repair_time(part)
		#print(part)
		item.setup(part, time)

func clear_list():
	for child in list.get_children():
		child.queue_free()
