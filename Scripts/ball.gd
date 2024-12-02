extends RigidBody2D


# Ball physics settings
@export var friction: float = 0.1
@export var bounce: float = 0.8
@export var spin_decay: float = 0.98
@export var momentum_decay: float = 0.99
@export var initial_mass: float = 1.0

# Cache the Sprite2D node for rotation
var sprite: Sprite2D
var grace_period = 0.5  # Time in seconds to ignore collision sounds after start
var time_since_start = 0.0

#####################################################################################################

func _ready():
	# Set up physics properties
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = friction
	physics_material_override.bounce = bounce
	mass = initial_mass
	angular_velocity = 0  # No initial spin
	
	# Get the Sprite2D node
	sprite = $Sprite2D

#####################################################################################################

func _physics_process(delta: float):
	time_since_start += delta

	# Apply momentum and spin decay
	linear_velocity *= momentum_decay
	angular_velocity *= spin_decay

	# Rotate the sprite to reflect the ball's spin
	if sprite:
		sprite.rotation += angular_velocity * delta

#####################################################################################################

func set_physics_properties(new_friction: float, new_bounce: float, 
	new_spin_decay: float) -> void:
	
	# Set the physics properties
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = new_friction
	physics_material_override.bounce = new_bounce
	spin_decay = new_spin_decay
	momentum_decay = 0.99  # Optional: Adjust or expose as needed

#####################################################################################################

func _on_body_entered(body: Node) -> void:
	if time_since_start < grace_period:
		return
	if body.is_in_group("balls"):
		print("Collided with another ball:", body.name)
		$BallHitAudio.play()
