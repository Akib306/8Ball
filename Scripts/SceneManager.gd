extends Node

var current_scene: Node = null

# Dictionary to hold data for scene transitions
var transition_data: Dictionary = {}  

func _ready() -> void:
	# Optionally, load the main menu at startup
	change_scene("res://Scenes/main_menu.tscn")

func change_scene(scene_path: String, data: Dictionary = {}) -> void:
	# Store the data for the new scene
	transition_data = data
	
	# Ensure the current scene is removed
	if current_scene:
		current_scene.queue_free()
		await get_tree().process_frame  # Wait for the scene to be freed

	# Load and add the new scene
	var new_scene = load(scene_path).instantiate()
	get_tree().get_root().add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene = new_scene

#func stop_all_audio() -> void:
	## Find all AudioStreamPlayer nodes and stop them
	#for node in get_tree().get_root().get_children():
		#if node is AudioStreamPlayer:
			#node.stop()
