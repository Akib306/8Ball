extends Control

@onready var button = $TextureRect/Button

func _ready() -> void:
	button.grab_focus()
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	SceneManager.change_scene("res://Scenes/main_menu.tscn")
