extends Control

var player: Player  # Current player
var powerup_manager: PowerUpManager  # Reference to PowerUpManager

# Update the power-up UI dynamically
func update_ui():
	var container = $HBoxContainer
	container.clear_children()  # Clear existing buttons

	if not player:
		print("No player assigned to PowerUpUI.")
		return

	# Create a button for each power-up in the player's inventory
	for i in range(player.inventory.size()):
		var power_up = player.inventory[i]

		# Create a button for the power-up
		var btn = Button.new()
		btn.text = str(power_up)  # Display power-up type
		btn.name = "PowerUp_" + str(i)

		# Store the index in the button metadata
		btn.set_meta("index", i)

		# Connect the button press event using Callable
		btn.pressed.connect(Callable(self, "_on_power_up_button_pressed").bind(btn))
		container.add_child(btn)

# Handle power-up button presses
func _on_power_up_button_pressed(button: Button):
	# Retrieve the stored index from the button
	var index = button.get_meta("index")

	if player:
		player.activate_power_up(index, powerup_manager)
		update_ui()  # Refresh the UI after activation
