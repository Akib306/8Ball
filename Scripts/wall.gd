extends Area2D
class_name Wall

@export var duration: float = 5.0  # Duration of the wall effect in seconds
@export var wall_size: Vector2 = Vector2(100, 20)  # Size of the wall (adjust as needed)
@export var player_color: Color = Color(1, 1, 1)  # Color for player identification

var is_placed: bool = false  # Tracks if the wall is placed

func _ready() -> void:
	# Set up collision shape
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = wall_size / 2  # Set size of collision box

	# Set up the ColorRect for visual representation
	$ColorRect.color = player_color  # Set the color to indicate the player
	$ColorRect.size = wall_size  # Adjust the size of the ColorRect

	# Set up and start the timer
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timeout"))  # Wrap in Callable
	add_child(timer)
	timer.start()

	# Enable preview mode initially
	set_as_top_level(true)  # Allow wall to move independently
	connect("area_entered", Callable(self, "_on_area_entered"))  

func _process(delta: float) -> void:
	if not is_placed:
		position = get_global_mouse_position()

func can_place_wall() -> bool:
	var table_bounds = Rect2(Vector2(0, 0), Vector2(1024, 576))
	return table_bounds.has_point(position)

func place_wall():
	if can_place_wall():
		is_placed = true
		print("Wall placed at", position)
	else:
		print("Invalid wall placement")

func _on_timeout():
	if is_placed:
		print("Wall duration ended; removing wall.")
		queue_free()

func _on_area_entered(area):
	if not is_placed:
		print("Cannot place wall here - overlaps with another object.")
