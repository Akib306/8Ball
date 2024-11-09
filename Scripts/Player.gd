extends Object
class_name Player

# Player attributes
var name: String
var type: String = ""  # "solids" or "stripes", assigned after the first shot
var score: int = 0
var is_turn: bool = false

# Power-up inventory with a maximum of two slots
var inventory: Array = []

# Initialize with name and turn status
func _init(name: String, is_turn: bool = false):
	self.name = name
	self.is_turn = is_turn

# Assign the player's ball type (solids or stripes)
func assign_type(ball_type: String):
	self.type = ball_type

# Toggle the player's turn
func toggle_turn():
	is_turn = !is_turn

# Add a power-up to the inventory if there's space
func add_to_inventory(power_up: Node2D):
	if inventory.size() >= 2:
		print(name, "has a full inventory. Cannot add more power-ups.")
		return

	inventory.append(power_up)
	power_up.hide()  # Hide the power-up until the player activates it
	print(name, " added power-up to inventory:", power_up)

# Activate a power-up from the inventory by index
func activate_power_up(index: int) -> void:
	if index >= 0 and index < inventory.size():
		var power_up = inventory[index]
		power_up.show()  # Make the power-up visible and ready to use
		if power_up.has_method("activate"):
			power_up.activate()  # Trigger the power-up's effect
		inventory.remove_at(index)  # Remove the power-up from the inventory after activation
		print(name, "activated power-up:", power_up)
	else:
		print("Invalid power-up index.")
