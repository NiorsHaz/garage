extends VBoxContainer

@onready var button: Button = $Button
@onready var progress: ProgressBar = $ProgressBar

signal part_selected(part: String)

var part_name: String


func setup(part: String) -> void:
	part_name = part
	button.text = part
	progress.value = 0
	button.disabled = false

func finished(part: String) -> void:
	part_name = part
	button.text = part
	progress.value = 100
	button.disabled = true

func set_progress(value: float) -> void:
	progress.value = clamp(value * 100.0, 0, 100)


func mark_finished() -> void:
	progress.value = 100
	button.disabled = true


func _on_button_pressed() -> void:
	emit_signal("part_selected", part_name)
