extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	AudioServer.set_bus_volume_db(0, linear_to_db($CenterContainer/VBoxContainer/AudioOptions/VBoxContainer/MasterSlider.value))
	AudioServer.set_bus_volume_db(1, linear_to_db($CenterContainer/VBoxContainer/AudioOptions/VBoxContainer/SFXSlider.value))
	AudioServer.set_bus_volume_db(2, linear_to_db($CenterContainer/VBoxContainer/AudioOptions/VBoxContainer/MusicSlider.value))


func _on_confirm_pressed():
	pass
