extends KinematicBody

const ACCELERATION = 7
const MAX_SPEED = 28
const FRICTION = 5


var velocity = Vector3.ZERO
var input_vector = Vector3.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	moveState(delta)

func moveState(delta):
	#Obracanie gracza - fajneee xD
	input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	input_vector.z = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector3.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
