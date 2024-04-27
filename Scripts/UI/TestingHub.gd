extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_lifeless_viewer_pressed():
	get_tree().change_scene_to_file("res://Scenes/LifelessViewer.tscn")

func _on_lifeless_creator_pressed():
	get_tree().change_scene_to_file("res://Scenes/LifelessCreator.tscn")

func _on_test_ai_pressed():
	get_tree().change_scene_to_file("res://Scenes/TestAI.tscn")
