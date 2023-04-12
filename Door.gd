extends Node3D
@export var open = false

var playback = null

#func _ready():
#	playback = $AnimationTree.get("parameters/playback")
	
func toggle_door(_body):
	open = !open
	
	if open:
		$AnimationPlayer.play("Open")
		print("Open")
	else:
		$AnimationPlayer.play("Close")
		print("Close")
