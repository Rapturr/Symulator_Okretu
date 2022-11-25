extends RigidBody


const ACCELERATION = 7
const MAX_SPEED = 28
const FRICTION = 5

var gear = 1;

var velocity = Vector3.ZERO
var input_vector = Vector3.ZERO

func _process(delta):
	var ocean = get_parent().get_node('Ocean')
	var wind = ocean.wind_direction
	var zm = ocean.get_wind()
	var pos = translation
	

	input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	#input_vector.z = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	input_vector = input_vector.normalized()
	
	var forward_force = Vector2(1,0).rotated(rotation.y+90)
	var wind_force = wind * gear
	var moving_force = Vector3(forward_force.x,0,forward_force.y) * MAX_SPEED * Vector3(wind_force.x,0,wind_force.y)
	#add_central_force(moving_force)
	add_torque(Vector3(0,input_vector.x*100,0))
	
	if Input.get_action_strength("ui_left"):
		print("Wiatr = ",zm.x)
		print("predkosc = ",moving_force)
	#if input_vector != Vector3.ZERO:
	#else:
	#	velocity.move_toward(Vector3.ZERO, FRICTION * delta)
		
	#add_central_force(input_vector)
	
	
