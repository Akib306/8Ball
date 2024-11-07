extends Control

@onready var main_menu = $Main
@onready var option_menu = $Main2


var menu_start_position = Vector2.ZERO
var menu_start_size = Vector2.ZERO

var curr_menu
var stack_menu := [] 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add any initial setup or logic here, if necessary.
	menu_start_position = Vector2(0,0)
	menu_start_size = get_viewport_rect().size
	curr_menu = main_menu
	
	
func go_to_next_menu(menu: String): 
	var next_menu = get_menu(menu)
	curr_menu.rect_position = Vector2(-menu_start_position.x, 0)
	next_menu.rect_position = menu_start_position
	stack_menu.append(curr_menu)
	curr_menu = next_menu

func go_to_prev_menu():
	var prev_menu = stack_menu.pop_back()
	if prev_menu != null: 
		prev_menu.rect_position = menu_start_position
		curr_menu.rect_position = Vector2(menu_start_position.x, 0)
		curr_menu = prev_menu
	

func get_menu(menu: String) -> Control:
	
	match menu:
		"main_menu":
			return main_menu
		"option_menu":
			return option_menu
		_:
			return main_menu 

func _on_options_pressed() -> void:
	go_to_next_menu("option_menu")


func _on_back_pressed() -> void:
	go_to_prev_menu()
