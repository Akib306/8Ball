extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	# Set default volume for buses to 50% (linear = 0.5)
	var default_volume_db = linear_to_db(0.5)
	
	# Set the default volume in AudioServer for each bus
	AudioServer.set_bus_volume_db(0, default_volume_db)  # Master
	AudioServer.set_bus_volume_db(1, default_volume_db)  # SFX
	AudioServer.set_bus_volume_db(2, default_volume_db)  # Music

	# Update slider values to reflect the default volume
	$VBoxContainer/MasterSlider.value = 0.5
	$VBoxContainer/SFXSlider.value = 0.5
	$VBoxContainer/MusicSlider.value = 0.5

func _on_music_slider_mouse_exited():
	release_focus()

func _on_sfx_slider_mouse_exited():
	release_focus()

func _on_master_slider_mouse_exited():
	release_focus()
