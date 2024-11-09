extends Node2D

# Enum to define power-up types
enum PowerUps { TELEPORT, WALL, MRBIG, TORNADO, REWIND, GHOST }

# Dictionary holding the paths to each power-up scene
const POWER_UP_SCENES = {
	PowerUps.TELEPORT: "",
	PowerUps.WALL: "res://Scenes/wall.tscn",
	PowerUps.MRBIG: "",
	PowerUps.TORNADO: "",
	PowerUps.REWIND: "",
	PowerUps.GHOST: "",
}

# Factory method for creating power-ups
func power_up_factory(power_up_type: int) -> Node2D:
	var power_up_scene_path = POWER_UP_SCENES.get(power_up_type, null)
	if power_up_scene_path:
		var power_up_scene = load(power_up_scene_path)
		return power_up_scene.instantiate()  # Instantiate the power-up scene
	else:
		print("Invalid power-up type.")
		return null
