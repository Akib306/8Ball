extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the slider range (0 to 100 for percentage)
	$CenterContainer/VBoxContainer/AudioOptions/VBoxContainer/MasterSlider.min_value = 0
	$CenterContainer/VBoxContainer/AudioOptions/VBoxContainer/MasterSlider.max_value = 100

	# Set the slider to default to 50% (middle position)
	$CenterContainer/VBoxContainer/AudioOptions/VBoxContainer/MasterSlider.value = 50

	# Set the audio bus volume based on 50% slider value
	AudioServer.set_bus_volume_db(0, percentage_to_db(50))

	# Connect the slider's value_changed signal
	$CenterContainer/VBoxContainer/AudioOptions/VBoxContainer/MasterSlider.connect("value_changed", Callable(self, "_on_master_slider_value_changed"))

# Converts slider percentage (0 to 100) to decibels (-50 to 30) proportionally
func percentage_to_db(percentage):
	var min_db = -50.0  # Minimum volume at -50 dB
	var max_db = 30.0   # Maximum volume at 30 dB

	# Linearly interpolate between min_db and max_db based on percentage
	return lerp(min_db, max_db, float(percentage) / 100.0)

# Update the bus volume when the slider value changes
func _on_master_slider_value_changed(value):
	# Convert percentage to dB and set bus volume
	var db_value = percentage_to_db(value)
	AudioServer.set_bus_volume_db(0, db_value)
	print("Slider Percentage:", value, " -> Volume (dB):", db_value)
