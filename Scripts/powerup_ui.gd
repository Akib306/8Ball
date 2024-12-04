extends Control
class_name PowerUpUI

var player: Player  # Current player
var powerup_manager: PowerUpManager  # Reference to PowerUpManager

func update_ui():
	var container = $HBoxContainer

	# Predefined slots
	var slots = container.get_children()

	# Assign power-ups to slots
	for i in range(slots.size()):
		var slot = slots[i]

		# If player has a power-up for this slot, update it
		if i < player.inventory.size():
			var power_up = player.inventory[i]
			slot.text = ""  # Clear placeholder text
			slot.icon = power_up.icon  # Assuming power-ups have an `icon` property
			slot.set_meta("index", i)  # Store the power-up index
			slot.disabled = false  # Enable the button
			slot.pressed.connect(Callable(self, "_on_power_up_button_pressed").bind(slot))
		else:
			# If no power-up, reset slot to default
			slot.text = "Empty Slot"
			slot.icon = null
			slot.set_meta("index", null)  # No power-up assigned
			slot.disabled = true  # Disable the button

func _on_power_up_button_pressed(button: Button):
	var index = button.get_meta("index")
	if index is int and player:
		player.activate_power_up(index, powerup_manager)
		update_ui()
