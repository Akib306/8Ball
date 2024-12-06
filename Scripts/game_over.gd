extends Control

@onready var button = $Button

func _ready() -> void:
	button.grab_focus()
	button.connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	# Remove the existing main scene instance
	var main_scene = get_tree().get_root().find_node("Main", true, false)
	if main_scene:
		main_scene.queue_free()
	
	# Go back to the main menu
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
