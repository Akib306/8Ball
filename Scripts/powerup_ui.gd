extends Control
class_name PowerUpUI

var player: Player  # Current player
var powerup_manager: PowerUpManager  # Reference to PowerUpManager

# Update the power-up UI dynamically
func update_ui():
	var container = $HBoxContainer
	
	# Remove all existing buttons (children) from the container
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()  # Free the button from memory

	if not player:
		print("No player assigned to PowerUpUI.")
		return

	# Create new buttons for the current player's inventory
	for i in range(player.inventory.size()):
		var power_up = player.inventory[i]
		var btn = Button.new()
		btn.text = str(power_up)  # Set the button text to the power-up name
		btn.set_meta("index", i)  # Store the index in metadata
		btn.pressed.connect(Callable(self, "_on_power_up_button_pressed").bind(btn))
		container.add_child(btn)  # Add the button to the container

func _on_power_up_button_pressed(button: Button):
	var index = button.get_meta("index")
	if player:
		player.activate_power_up(index, powerup_manager)
		update_ui()
