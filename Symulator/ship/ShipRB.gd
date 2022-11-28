tool
extends RigidBody

const MAX_SPEED = 124

var gear = 1;

var velocity = Vector3.ZERO
var input_vector = Vector3.ZERO

var currentSpeed = 0;

func _process(_delta):
	var waves = get_parent().get_node('Waves')
	var wind = waves.windDirection
	
	input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	input_vector = input_vector.normalized()
	
	var forward_force = Vector2(0.2,0).rotated(-rotation.y+90)
	forward_force += wind
	var moving_force = Vector3(forward_force.x,0,forward_force.y) * MAX_SPEED * Vector3(wind.x,0,wind.y)*gear
	add_central_force(Vector3(forward_force.x, 0, forward_force.y)*MAX_SPEED*gear)
	add_torque(Vector3(0,input_vector.x*100,0))
	if Input.get_action_strength("lower"):
		currentSpeed = sqrt(linear_velocity.x*linear_velocity.x+linear_velocity.y*linear_velocity.y)
		print("Wiatr = ",wind.x)
		print("moving_force = ",moving_force)
		print("speed = ",currentSpeed)
