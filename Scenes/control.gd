extends Control

@onready var mainMenu = $Main_menu
@onready var optionsMenu = $Options_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	optionsMenu.visible = false 


func to_options(): 
	mainMenu.visible = false
	optionsMenu.visible = true

	
func to_main():
	mainMenu.visible = true
	optionsMenu.visible = false




func _on_option_pressed() -> void:
	to_options()



func _on_back_pressed() -> void:
	to_main()
