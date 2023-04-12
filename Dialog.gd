extends Node3D
signal yeah
func dialog_test(_body):
	DialogueManager.show_example_dialogue_balloon(load("res://test.dialogue"),"talktothisbutton")
	return

