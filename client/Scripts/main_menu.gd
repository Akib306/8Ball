extends Control

@onready var mainMenu = $Main_menu
@onready var optionsMenu = $Credits
@onready var menu_buttons = %MenuButtons
@onready var option_buttons = %OptionButtons
@onready var credit_name = $Credits/CanvasLayer/Label


var state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../bg_music".play()
	optionsMenu.visible = false
	credit_name.visible = false
	state = "Main"
	focus_button()
	

func to_options(): 
	mainMenu.visible = false
	optionsMenu.visible = true
	credit_name.visible = true

func on_visibility_change(): 
	if visible:
		focus_button() 

func focus_button():
	if menu_buttons || option_buttons:
		var button: Button = menu_buttons.get_child(0)
		var option_button: Button = option_buttons.get_child(0)
		if state == "Main": 
			if button is Button: 
				button.grab_focus()
		elif state == "Options":
			if option_button is Button: 
				option_button.grab_focus() 

func to_main():
	mainMenu.visible = true
	optionsMenu.visible = false
	credit_name.visible = false

func _on_option_pressed() -> void:
	to_options()
	state = "Options"
	focus_button()
	

func _on_back_pressed() -> void:
	to_main()
	state = "Main"
	focus_button()
	
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	$"../bg_music".stop()
	SceneManager.change_scene("res://Scenes/main.tscn")
	hide()
	
