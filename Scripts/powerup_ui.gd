extends Control

var player: Player  # Reference to the player instance
@export var power_up_button_scene: PackedScene  # Reference to the PowerUpButton.tscn scene

# Dictionary mapping power-up names to icon textures
var power_up_icons := {
	"TELEPORT": "",
	"WALL": load("res://path/to/wall_icon.png") as Texture2D,
	"MRBIG": "",
	"TORNADO": "",
	"REWIND": "",
	"GHOST": "",
}


# Sets the current player and refreshes the power-up buttons
func set_current_player(new_player: Player):
	player = new_player
	
# Update the UI based on the player's current inventory
func update_power_up_buttons():
	# Clear existing buttons
	for child in $HBoxContainer.get_children():
		child.queue_free()

	# Create a button for each power-up in the player's inventory
	for i in range(player.inventory.size()):
		var power_up = player.inventory[i]
		var button = power_up_button_scene.instantiate()
		
		# Set up button properties and add icon
		button.get_node("Icon").texture = power_up_icons[i] 
		#button.text = power_up.name  # Optional: Display the power-up name

		# Connect the pressed signal with the correct syntax for Godot 4
		button.connect("pressed", Callable(self, "_on_power_up_button_pressed").bind(i))

		$HBoxContainer.add_child(button)  # Add the button to the container

# Callback for button press to activate power-up
func _on_power_up_button_pressed(index: int):
	player.activate_power_up(index)
	update_power_up_buttons()  # Refresh the UI to remove the used power-up
