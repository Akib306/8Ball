extends Control
class_name PowerUpUI

var player: Player  # Current player
var powerup_manager: PowerUpManager  # Reference to PowerUpManager

func update_ui():
	var container = $VBoxContainer/HBoxContainer

	# Predefined slots
	var slots = container.get_children()
	
	for i in range(slots.size()):
		var slot = slots[i]

		# Disconnect the signal if already connected
		if slot.is_connected("pressed", Callable(self, "_on_power_up_button_pressed")):
			slot.disconnect("pressed", Callable(self, "_on_power_up_button_pressed"))

		# Access the TextureRect child of the button
		var texture_rect = slot.get_node("TextureRect")

		# If player has a power-up for this slot, update it
		if i < player.inventory.size():
			var power_up = player.inventory[i]
			slot.text = ""  # Clear placeholder text
			texture_rect.texture = power_up.icon  # Assign the icon to TextureRect
			texture_rect.visible = true
			slot.set_meta("index", i)  # Store the power-up index
			slot.disabled = false  # Enable the button
			slot.pressed.connect(Callable(self, "_on_power_up_button_pressed").bind(slot))
		else:
			# If no power-up, reset slot to default
			slot.text = "Empty Slot"
			texture_rect.texture = null  # Remove the icon
			texture_rect.visible = false
			slot.set_meta("index", null)  # No power-up assigned
			slot.disabled = true

func _on_power_up_button_pressed(button: Button):
	var index = button.get_meta("index")
	if index is int and player:
		player.activate_power_up(index, powerup_manager)
		update_ui()
