extends Control

@onready var list: VBoxContainer = $List

@onready var repair_item_scene: PackedScene = preload("res://Scenes/UI/repair_part.tscn")
var items := {}

var current_car: Car

signal selected_part(part: String, car: Car)

func open_for_car(car: Car) -> void:
	if car.repair_points != []:
		visible = true
		current_car = car
		clear_list()
		items.clear()

		for part in car.repair_points:
			var item = repair_item_scene.instantiate()
			list.add_child(item)
			item.setup(part)
			item.connect("part_selected", start_repair_for)
			items[part] = item

func clear_list():
	for child in list.get_children():
		child.queue_free()

func start_repair_for(part: String) -> void:
	print("repair : " + part + " for car : " + current_car.name)
	emit_signal("selected_part", part, current_car)

func update_part_progress(part: String, progress: float) -> void:
	if items.has(part):
		items[part].set_progress(progress)

func finish_part(part: String) -> void:
	if items.has(part):
		items[part].mark_finished()
