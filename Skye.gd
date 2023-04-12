extends CharacterBody3D

@onready var armature = $Rig/Skeleton3D
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var anim_tree = $AnimationTree
@onready var camera = $SpringArmPivot/SpringArm3D/Camera3D
var SPEED 
var Default_speed=6.5
var Sprint_speed=27
var def_anim=1
var sprint_anim=1.6
var JUMP_LERP = 0.0
var Run_lerp = 0.0
var Jump_L_thres = 1.0
var fovlerp = 0.0
@export var movement = Movementstuff.moveison
const LERP_VAL = 0.15
const THINGY = 0.010
const JUMP_VELOCITY = 8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x*THINGY)
		spring_arm.rotate_x(-event.relative.y*THINGY)
		spring_arm.rotation.x= clamp(spring_arm.rotation.x, -PI/4, PI/4)
		
	if event.is_action_pressed("Yeah"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				

func _physics_process(delta):
	movement = Movementstuff.moveison
	if movement == true:
		SPEED=int(Default_speed)
		anim_tree.set("parameters/TimeScale/scale", def_anim)
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		# Handle Jump.
		


	#ANIMATIONS AND COOL stuff LIKE THAT
		
		anim_tree.set("parameters/Blend2/blend_amount", JUMP_LERP)
		if  is_on_floor():
			JUMP_LERP = lerpf(JUMP_LERP,0.0,10*delta)
		else:
			JUMP_LERP = lerpf(JUMP_LERP,Jump_L_thres,10*delta)
	#	if velocity.y > JUMP_VELOCITY-1:
	#		JUMP_LERP = lerpf(JUMP_LERP,1.0,20*delta)
		print(Jump_L_thres)
		if movement == true:
			Jump_L_thres=1.0
			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			if Input.is_action_pressed ("run") and velocity.length() > 1.2 :
				SPEED=int(Sprint_speed)
				anim_tree.set("parameters/TimeScale/scale", sprint_anim)
				Run_lerp= lerpf(Run_lerp,0.6,15*delta)
				fovlerp =lerpf(fovlerp,114.7,15*delta)
				#print(velocity.length())
				Jump_L_thres=0.4
				
			else:
				Run_lerp= lerpf(Run_lerp,0,15*delta)
				fovlerp =lerpf(fovlerp,106.9,15*delta)
				
			print(fovlerp)
			camera.set("fov",fovlerp)
			anim_tree.set("parameters/Blend2 2/blend_amount", Run_lerp)
			var input_dir = Input.get_vector("left", "right", "forward", "back")
			var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
			if direction:
				velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
				velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
				armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
			else:
				velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
				velocity.z = lerp(velocity.z, 0.0, LERP_VAL)

			anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
			move_and_slide()



