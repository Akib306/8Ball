extends Node

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

func start_timer():
	timer.start(turn_time)
	label.visible = true
	update_label()

func stop_timer():
	timer.stop()
	label.visible = false

func update_label():
	if not timer.is_stopped():
		label.text = str(round(timer.time_left))

func _on_timeout():
	label.visible = false
	emit_signal("timeout")
