extends Node
class_name TurnTimer  # Registers the TurnTimer class with Godot
signal timeout

@export var turn_time := 10.0  # Set default turn time
@onready var timer: Timer = Timer.new()
@onready var label: Label = Label.new()

func _ready():
	# Add the Timer node
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timeout"))

	# Add the Label node (optional for displaying time)
	add_child(label)
	label.visible = false
	label.text = str(turn_time)

func _process(delta: float) -> void:
	# Update the label text every frame while the timer is active
	if not timer.is_stopped():
		update_label()

func start_timer():
	# Start the timer and make the label visible
	timer.start(turn_time)
	label.visible = true
	label.text = str(turn_time)  # Reset the text to the full turn time
	set_process(true)  # Enable processing to update the label

func stop_timer():
	# Stop the timer and hide the label
	timer.stop()
	label.visible = false
	set_process(false)  # Disable processing when the timer is stopped

func update_label():
	# Update the label text to show remaining time
	if not timer.is_stopped():
		label.text = str(round(timer.time_left))

func _on_timeout():
	# Emit a signal for timeout and hide the label
	label.visible = false
	set_process(false)  # Disable processing when the timer times out
	emit_signal("timeout")
