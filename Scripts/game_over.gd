extends Control

@onready var button = $TextureRect/Button
@onready var label = $TextureRect/Label

func _ready() -> void:
	# Get the winner's name from the SceneManager
	$"../bg_music".play()
	var winner_name = SceneManager.transition_data.get("winner_name", "Unknown")
	
	# Update the label text
	label.text = winner_name + " wins!"
	
	# Connect the button to return to the main menu
	button.grab_focus()
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	$"../bg_music".stop()
	SceneManager.change_scene("res://Scenes/main_menu.tscn")
