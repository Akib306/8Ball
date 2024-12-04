extends Node
class_name PowerUpFactory

enum PowerUps {MRBIG}


# Create a power-up based on its type/index
static func create_power_up(power_up_type: int) -> PowerUp:
	match power_up_type:
		PowerUps.MRBIG:
			return MrBigPowerUp.new()
		#PowerUps.TELEPORT:
			#return TeleportPowerUp.new()
		#PowerUps.WALL:
			#return WallPowerUp.new()
		#PowerUps.MRBIG:
			#return MrBigPowerUp.new()
		#PowerUps.TORNADO:
			#return TornadoPowerUp.new()
		#PowerUps.REWIND:
			#return RewindPowerUp.new()
		#PowerUps.GHOST:
			#return GhostPowerUp.new()
		_:
			print("Unknown power-up type!")
			return null

# Return the total number of power-ups available
static func get_total_power_ups() -> int:
	return len(PowerUps)
