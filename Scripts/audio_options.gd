extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Define the min and max dB values for your sliders
	var min_db = -80
	var max_db = 0
	
	# Set the slider range based on the linear equivalent of the dB range
	$VBoxContainer/MasterSlider.min_value = db_to_linear(min_db)
	$VBoxContainer/MasterSlider.max_value = db_to_linear(max_db)
	
	# Initialize the MasterSlider with the current bus volume
	var current_volume_db = AudioServer.get_bus_volume_db(0)
	$VBoxContainer/MasterSlider.value = db_to_linear(current_volume_db)

func _on_music_slider_mouse_exited():
	release_focus()

func _on_sfx_slider_mouse_exited():
	release_focus()

func _on_master_slider_mouse_exited():
	release_focus()
