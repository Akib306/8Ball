extends Control

@onready var button = $TextureRect/Button

func _ready() -> void:
	button.grab_focus()
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	# Find and remove the existing main scene instance
	var main_scene = null
	for child in get_tree().get_root().get_children():
		if child.name == "Main":
			main_scene = child
			break
	
	if main_scene:
		main_scene.queue_free()
		await get_tree().process_frame  # Wait for the next frame to ensure cleanup
	
	# Go back to the main menu
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
