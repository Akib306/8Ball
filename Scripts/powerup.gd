class_name PowerUp
extends Node

enum EffectType { INSTANT, TURN_BASED }
var effect_type: EffectType = EffectType.INSTANT
var powerupOwner: Player = null  # The player who owns/activates this power-up
@export var icon: Texture2D = null
# Called when the power-up is activated
func activate():
	pass

# Called at the end of the owner's turn (only for turn-based power-ups)
func on_turn_end():
	pass
