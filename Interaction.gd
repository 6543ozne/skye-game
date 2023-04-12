extends StaticBody3D

class_name Interactable

signal interacted(body)

#prompt message i.e. keymapping to press
@export var prompt_message = "Interact"

#Keymapping (Input mapping, project settings)
@export var prompt_action = "Interact"

func get_prompt():
	var key_name = ""
	
	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = "E"
	return prompt_message + "\n[" + key_name + "]"

func interact(body):
#Print to console for debugging - optional
#	print(body.name, " Interacted!")
	if Movementstuff.moveison == true:
		emit_signal("interacted", body)
