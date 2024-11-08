extends Object

class_name Player

var name: String
var type: String = "" # No type initially assigned
var score: int = 0
var is_turn: bool = false

func _init(name: String, is_turn: bool = false):
	self.name = name
	self.is_turn = is_turn

func assign_type(ball_type: String):
	self.type = ball_type

func toggle_turn():
	is_turn = !is_turn
