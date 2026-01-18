extends VBoxContainer

@onready var button: Button = $Button
@onready var progress: ProgressBar = $ProgressBar

var part_name: String
var repair_time: float
var elapsed := 0.0
var repairing := false

func setup(part: String, total_time: float) -> void:
	part_name = part
	repair_time = total_time
	print(part)
	button.text = part
	progress.value = 0

func _process(delta):
	if repairing:
		elapsed += delta
		progress.value = (elapsed / repair_time) * 100.0

		if elapsed >= repair_time:
			repairing = false
			progress.value = 100
			button.disabled = true

func _on_button_pressed():
	repairing = true
