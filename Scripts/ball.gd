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
		$BallHitAudio.play()

#func handle_collision(other_ball: RigidBody2D):
	#emit_signal("ball_collided", other_ball)
	#
	## Calculate relative velocity
	#var relative_velocity = other_ball.linear_velocity - linear_velocity
	#
	## Apply spin transfer
	#var spin_transfer = relative_velocity.length() * 0.05
	#
	#angular_velocity -= spin_transfer
	#other_ball.angular_velocity += spin_transfer
	#
	## Adjust momentum for elastic collision
	#adjust_momentum(other_ball)

#####################################################################################################

#func adjust_momentum(other_ball: RigidBody2D):
	## Use elastic collision formulas
	#var v1 = linear_velocity
	#var v2 = other_ball.linear_velocity
	#var m1 = mass
	#var m2 = other_ball.mass
	#
	#var new_v1 = ((m1 - m2) / (m1 + m2)) * v1 + ((2 * m2) / (m1 + m2)) * v2
	#var new_v2 = ((2 * m1) / (m1 + m2)) * v1 + ((m2 - m1) / (m1 + m2)) * v2
	#
	## Apply new velocities
	#linear_velocity = new_v1
	#other_ball.linear_velocity = new_v2

#####################################################################################################

#func _on_Ball_body_entered(other_body):
	#if other_body.is_in_group("balls"):
		#handle_collision(other_body)

#####################################################################################################
